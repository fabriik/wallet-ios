//
//  ApplicationController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-21.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import WalletKit
import UserNotifications
import IQKeyboardManagerSwift
#if canImport(WidgetKit)
import WidgetKit
#endif

private let timeSinceLastExitKey = "TimeSinceLastExit"
private let shouldRequireLoginTimeoutKey = "ShouldRequireLoginTimeoutKey"

class ApplicationController: Subscriber, Trackable {
    
    fileprivate var application: UIApplication?

    static let initialLaunchCount = 0
    
    let window = UIWindow()
    var coordinator: BaseCoordinator?
    
    private var startFlowController: StartFlowPresenter?
    private var modalPresenter: ModalPresenter?
    private var alertPresenter: AlertPresenter?
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))

    var rootNavigationController: RootNavigationController? {
        guard let root = window.rootViewController as? RootNavigationController else { return nil }
        return root
    }
    
    var homeScreenViewController: HomeScreenViewController? {
        guard   let rootNavController = rootNavigationController,
                let homeScreen = rootNavController.viewControllers.first as? HomeScreenViewController
        else {
                return nil
        }
        return homeScreen
    }
        
    private let coreSystem: CoreSystem!
    private var keyStore: KeyStore!

    private var launchURL: URL?
    private var urlController: URLController?
    private let notificationHandler = NotificationHandler()
    private var appRatingManager = AppRatingManager()
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    private var shouldDisableBiometrics = false
    
    private var isReachable = true {
        didSet {
            if oldValue == false && isReachable {
                self.retryAfterIsReachable()
            }
        }
    }

    // MARK: - Init/Launch

    init() {
        do {
            self.keyStore = try KeyStore.create()
            self.coreSystem = CoreSystem(keyStore: keyStore)
        } catch let error { // only possible exception here should be if the keychain is inaccessible
            print("error initializing key store: \(error)")
            fatalError("error initializing key store")
        }

        isReachable = Reachability.isReachable
    }

    /// didFinishLaunchingWithOptions
    func launch(application: UIApplication, options: [UIApplication.LaunchOptionsKey: Any]?) {
        handleLaunchOptions(options)
        application.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)

        UNUserNotificationCenter.current().delegate = notificationHandler
        EventMonitor.shared.register(.pushNotifications)

        mainSetup()
        setupKeyboard()
        Reachability.addDidChangeCallback({ isReachable in
            self.isReachable = isReachable
        })

        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func bumpLaunchCount() {
        guard !keyStore.noWallet else { return }
        UserDefaults.appLaunchCount = (UserDefaults.appLaunchCount + 1)
    }
    
    private func mainSetup() {
        setupDefaults()
        setupAppearance()
        setupRootViewController()
        window.makeKeyAndVisible()
        
        alertPresenter = AlertPresenter(window: window)
        modalPresenter = ModalPresenter(keyStore: keyStore,
                                        system: coreSystem,
                                        window: window,
                                        alertPresenter: alertPresenter)
        
        // Start collecting analytics events. Once we have a wallet, startBackendServices() will
        // notify `Backend.apiClient.analytics` so that it can upload events to the server.
        Backend.apiClient.analytics?.startCollectingEvents()

        appRatingManager.start()

        Store.subscribe(self, name: .wipeWalletNoPrompt, callback: { [weak self] _ in
            self?.wipeWalletNoPrompt()
        })
        
        Store.subscribe(self, name: .didWipeWallet) { [unowned self] _ in
            if let modalPresenter = self.modalPresenter {
                Store.unsubscribe(modalPresenter)
            }
            self.modalPresenter = nil
            self.rootNavigationController?.viewControllers = []
            
            self.setupRootViewController()
            self.decideFlow()
        }
        
        initializeAssets(completionHandler: { [weak self] in
            self?.decideFlow()
        })
    }
    
    func decideFlow() {
        if let nvc = rootNavigationController {
            coordinator = BaseCoordinator(navigationController: nvc)
        }
        
        if keyStore.noWallet {
            enterOnboarding()
        } else {
            unlockExistingAccount()
        }
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.disabledToolbarClasses = [SendViewController.self, AmountViewController.self]
    }
    
    private func enterOnboarding() {
        guardProtected(queue: DispatchQueue.main) {
            guard let startFlowController = self.startFlowController, self.keyStore.noWallet else { return assertionFailure() }
            startFlowController.startOnboarding { [unowned self] account in
                self.setupSystem(with: account)
                Store.perform(action: LoginSuccess())
            }
        }
    }
    
    /// Loads the account for initial launch and initializes the core system
    /// Prompts for login if account needs to be recreated from seed
    private func unlockExistingAccount() {
        guardProtected(queue: DispatchQueue.main) {
            guard let startFlowController = self.startFlowController, !self.keyStore.noWallet else { return assertionFailure() }
            Store.perform(action: PinLength.Set(self.keyStore.pinLength))
            startFlowController.startLogin { [unowned self] account in
                self.setupSystem(with: account)
            }
        }
    }
    
    /// Initialize the core system with an account
    /// Launch/authenticate with BRDAPI
    /// Initiate KVStore sync
    /// On KVStore sync complete, stand-up Core
    /// Core sync must not begin until KVStore sync completes
    private func setupSystem(with account: Account) {
        // Authenticate with BRDAPI backend
        Backend.connect(authenticator: keyStore as WalletAuthenticator)
        Backend.sendLaunchEvent()
        Backend.apiClient.analytics?.onWalletReady()
        
        DispatchQueue.global(qos: .userInitiated).async {
            Backend.kvStore?.syncAllKeys { [weak self] error in
                print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
                Store.trigger(name: .didSyncKVStore)
                guard let weakSelf = self else { return }
                weakSelf.setWalletInfo(account: account)
                weakSelf.coreSystem.create(account: account,
                                           authToken: E.apiToken,
                                           btcWalletCreationCallback: weakSelf.handleDeferedLaunchURL) {
                    weakSelf.modalPresenter = ModalPresenter(keyStore: weakSelf.keyStore,
                                                             system: weakSelf.coreSystem,
                                                             window: weakSelf.window,
                                                             alertPresenter: weakSelf.alertPresenter)
                    weakSelf.coreSystem.connect()
                }
            }
        }
        Backend.apiClient.updateExperiments()
        Backend.updateExchangeRates()
        Backend.apiClient.fetchAnnouncements()
    }
    
    private func handleDeferedLaunchURL() {
        // deep link handling
        self.urlController = URLController(walletAuthenticator: self.keyStore)
        if let url = self.launchURL {
            _ = self.urlController?.handleUrl(url)
            self.launchURL = nil
        }
    }
    
    /// background init of assets / animations
    private func initializeAssets(completionHandler: @escaping () -> Void) {
        _ = Rate.symbolMap //Initialize currency symbol map
        
        Backend.apiClient.updateBundles { _ in
            completionHandler()
        }
        
        // Set up the animation frames early during the startup process so that they're
        // ready to roll by the time the home screen is displayed.
        RewardsIconView.prepareAnimationFrames()
    }
    
    private func handleLaunchOptions(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let activityDictionary = options?[.userActivityDictionary] as? [String: Any] else { return }
        guard let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity else { return }
        guard let url = activity.webpageURL else { return }
        
        //handle gift url at launch
        launchURL = url
        shouldDisableBiometrics = true
    }
    
    private func setupDefaults() {
        if UserDefaults.standard.object(forKey: shouldRequireLoginTimeoutKey) == nil {
            UserDefaults.standard.set(60.0*3.0, forKey: shouldRequireLoginTimeoutKey) //Default 3 min timeout
        }
    }
    
    // MARK: - Lifecycle
    
    func willEnterForeground() {
        guard !keyStore.noWallet else { return }
        bumpLaunchCount()
        Backend.sendLaunchEvent()
        if shouldRequireLogin() {
            Store.perform(action: RequireLogin())
        }
        resume()
        coreSystem.updateFees()
    }

    func didEnterBackground() {
        pause()
        //Save the backgrounding time if the user is logged in
        if !Store.state.isLoginRequired {
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: timeSinceLastExitKey)
        }

        Backend.kvStore?.syncAllKeys { error in
            print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
            Store.trigger(name: .didSyncKVStore)
        }

        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    private func resume() {
        fetchBackendUpdates()
        coreSystem.resume()
    }
    
    private func pause() {
        coreSystem.pause()
    }

    private func shouldRequireLogin() -> Bool {
        let then = UserDefaults.standard.double(forKey: timeSinceLastExitKey)
        let timeout = UserDefaults.standard.double(forKey: shouldRequireLoginTimeoutKey)
        let now = Date().timeIntervalSince1970
        return now - then > timeout
    }
    
    private func retryAfterIsReachable() {
        guard !keyStore.noWallet else { return }
        resume()
    }
    
    func willResignActive() {
        applyBlurEffect()
        checkForNotificationSettingsChange(appActive: false)
        cacheBalances()
    }
    
    func didBecomeActive() {
        removeBlurEffect()
        checkForNotificationSettingsChange(appActive: true)
    }

    // MARK: Background Task Support

    private func beginBackgroundTask() {
        guard backgroundTaskID == .invalid else { return assertionFailure() }
        UIApplication.shared.beginBackgroundTask {
            self.endBackgroundTask()
        }
    }

    private func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundTaskID)
        self.backgroundTaskID = .invalid
    }
    
    /// Initialize WalletInfo in KV-store. Needed prior to creating the System.
    private func setWalletInfo(account: Account) {
        guard let kvStore = Backend.kvStore, WalletInfo(kvStore: kvStore) == nil else { return }
        print("[KV] created new WalletInfo")
        let walletInfo = WalletInfo(name: L10n.AccountHeader.defaultWalletName)
        walletInfo.creationDate = account.timestamp
        _ = try? kvStore.set(walletInfo)
    }
    
    /// Fetch updates from backend services.
    private func fetchBackendUpdates() {
        DispatchQueue.global(qos: .utility).async {
            Backend.kvStore?.syncAllKeys { error in
                print("[KV] finished syncing. result: \(error == nil ? "ok" : error!.localizedDescription)")
                Store.trigger(name: .didSyncKVStore)
            }
        }

        Backend.apiClient.updateExperiments()
        Backend.updateExchangeRates()
        Backend.apiClient.fetchAnnouncements()
    }
    
    // MARK: - UI
    
    private func setupRootViewController() {
        let navigationController = RootNavigationController()
        window.rootViewController = navigationController
        
        startFlowController = StartFlowPresenter(keyMaster: keyStore,
                                                 rootViewController: navigationController,
                                                 shouldDisableBiometrics: shouldDisableBiometrics,
                                                 createHomeScreen: createHomeScreen)
    }
    
    private func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.header]
        let backImage = #imageLiteral(resourceName: "BackArrowWhite").image(withInsets: UIEdgeInsets(top: 0.0, left: 8.0, bottom: 2.0, right: 0.0))
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        // hide back button text
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(#imageLiteral(resourceName: "TransparentPixel"), for: .normal, barMetrics: .default)
        UISwitch.appearance().onTintColor = Theme.accent
    }
    
    private func addHomeScreenHandlers(homeScreen: HomeScreenViewController,
                                       navigationController: UINavigationController) {
        
        homeScreen.didSelectCurrency = { [unowned self] currency in
            if currency.isBRDToken, UserDefaults.shouldShowBRDRewardsAnimation {
                let name = self.makeEventName([EventContext.rewards.name, Event.openWallet.name])
                self.saveEvent(name, attributes: ["currency": currency.code])
            }
            
            let wallet = self.coreSystem.wallet(for: currency)
            let accountViewController = AccountViewController(currency: currency, wallet: wallet)
            navigationController.pushViewController(accountViewController, animated: true)
        }
        
        homeScreen.didTapBuy = { url, reservationCode in
            let partnershipAlertShown = UserDefaults.standard.bool(forKey: "ShownBuyAlert")
            
            guard !partnershipAlertShown else {
                Store.perform(action: RootModalActions.Present(modal: .buy(url: url, reservationCode: reservationCode, currency: nil)))
                return
            }
            
            UserDefaults.standard.set(true, forKey: "ShownBuyAlert")
            let message = "Fabriik is providing Buy functionality through Wyre, a third-party API provider."
            
            let alert = UIAlertController(title: "Partnership note",
                                          message: message,
                                          preferredStyle: .alert)
            let continueAction = UIAlertAction(title: L10n.Button.continueAction, style: .default) { _ in
                Store.perform(action: RootModalActions.Present(modal: .buy(url: url, reservationCode: reservationCode, currency: nil)))
            }
            
            alert.addAction(continueAction)
            navigationController.present(alert, animated: true, completion: nil)
        }
        
        homeScreen.didTapTrade = { [weak self] in
            let partnershipAlertShown = UserDefaults.standard.bool(forKey: "ShownSwapAlert")
            
            guard !partnershipAlertShown else {
                self?.openSwapScreen()
                return
            }
            
            UserDefaults.standard.set(true, forKey: "ShownSwapAlert")
            let message = "Fabriik is providing Swap functionality through Changelly, a third-party API provider."
            
            let alert = UIAlertController(title: "Partnership note",
                                          message: message,
                                          preferredStyle: .alert)
            let continueAction = UIAlertAction(title: L10n.Button.continueAction, style: .default) { _ in
                self?.openSwapScreen()
            }
            
            alert.addAction(continueAction)
            navigationController.present(alert, animated: true, completion: nil)
        }
        
        homeScreen.didTapProfile = { [unowned self] in
            coordinator?.start()
        }
        
        homeScreen.didTapMenu = { [unowned self] in
            self.modalPresenter?.presentMenu()
        }
        
        homeScreen.didTapManageWallets = { [unowned self] in
            guard let assetCollection = self.coreSystem.assetCollection else { return }
            let vc = ManageWalletsViewController(assetCollection: assetCollection, coreSystem: self.coreSystem)
            let nc = UINavigationController(rootViewController: vc)
            nc.setDarkStyle()
            navigationController.present(nc, animated: true, completion: nil)
        }
    }
    
    func openSwapScreen() {
        let currencies = coreSystem.assetCollection?.allAssets.compactMap { $0.value.code } ?? []
        Store.perform(action: RootModalActions.Present(modal: .trade(availibleCurrencies: currencies, amount: 1)))
    }
    
    /// Creates an instance of the home screen. This may be invoked from StartFlowPresenter.presentOnboardingFlow().
    private func createHomeScreen(navigationController: UINavigationController) -> HomeScreenViewController {
        let homeScreen = HomeScreenViewController(walletAuthenticator: keyStore as WalletAuthenticator,
                                                  coreSystem: coreSystem)
        
        addHomeScreenHandlers(homeScreen: homeScreen, navigationController: navigationController)
        
        return homeScreen
    }
    
    private func applyBlurEffect() {
        guard !Store.state.isLoginRequired && !Store.state.isPromptingBiometrics else { return }
        blurView.alpha = 1.0
        blurView.frame = window.frame
        window.addSubview(blurView)
    }
    
    private func cacheBalances() {
        Store.state.orderedWallets.forEach {
            guard let balance = $0.balance else { return }
            UserDefaults.saveBalance(balance, forCurrency: $0.currency)
        }
    }
    
    private func removeBlurEffect() {
        let duration = Store.state.isLoginRequired ? 0.4 : 0.1 // keep content hidden if lock screen about to appear on top
        UIView.animate(withDuration: duration, animations: {
            self.blurView.alpha = 0.0
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }
    
    // do not call directly, instead use wipeWalletNoPrompt trigger so other subscribers are notified
    private func wipeWalletNoPrompt() {
        let activity = BRActivityViewController(message: L10n.WipeWallet.wiping)
        var topViewController = rootNavigationController as UIViewController?
        while let newTopViewController = topViewController?.presentedViewController {
            topViewController = newTopViewController
        }
        topViewController?.present(activity, animated: true, completion: nil)
        
        let success = keyStore.wipeWallet()
        guard success else { // unexpected error writing to keychain
            activity.dismiss(animated: true)
            topViewController?.showAlert(title: L10n.WipeWallet.failedTitle, message: L10n.WipeWallet.failedMessage)
            return
        }
        
        self.coreSystem.shutdown {
            DispatchQueue.main.async {
                Backend.disconnectWallet()
                Store.perform(action: Reset())
                activity.dismiss(animated: true) {
                    Store.trigger(name: .didWipeWallet)
                }
            }
        }
    }
}

extension ApplicationController {
    func open(url: URL) -> Bool {
        //If this is the same as launchURL, it has already been handled in didFinishLaunchingWithOptions
        guard launchURL != url else { return true }
        if let urlController = urlController {
            return urlController.handleUrl(url)
        } else {
            launchURL = url
            return false
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            return open(url: userActivity.webpageURL!)
        }
        return false
    }
}

// MARK: - Push notifications
extension ApplicationController {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard UserDefaults.pushToken != deviceToken else { return }
        UserDefaults.pushToken = deviceToken
        Backend.apiClient.savePushNotificationToken(deviceToken)
        Store.perform(action: PushNotifications.SetIsEnabled(true))
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("[PUSH] failed to register for remote notifications: \(error.localizedDescription)")
        Store.perform(action: PushNotifications.SetIsEnabled(false))
    }
    
    private func checkForNotificationSettingsChange(appActive: Bool) {
        guard Backend.isConnected else { return }
        
        if appActive {
            // check if notification settings changed
            NotificationAuthorizer().areNotificationsAuthorized { authorized in
                DispatchQueue.main.async {
                    if authorized {
                        if !Store.state.isPushNotificationsEnabled {
                            self.saveEvent("push.enabledSettings")
                        }
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        if Store.state.isPushNotificationsEnabled, let pushToken = UserDefaults.pushToken {
                            self.saveEvent("push.disabledSettings")
                            Store.perform(action: PushNotifications.SetIsEnabled(false))
                            Backend.apiClient.deletePushNotificationToken(pushToken)
                        }
                    }
                }
            }
        } else {
            if !Store.state.isPushNotificationsEnabled, let pushToken = UserDefaults.pushToken {
                Backend.apiClient.deletePushNotificationToken(pushToken)
            }
        }
    }
}
