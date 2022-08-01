//
//  Coordinator.swift
//  
//
//  Created by Rok Cresnik on 01/12/2021.
//

import UIKit

protocol BaseControllable: UIViewController {

    associatedtype CoordinatorType: CoordinatableRoutes
    var coordinator: CoordinatorType? { get set }
}

protocol Coordinatable: CoordinatableRoutes {

    // TODO: should eventually die
    var modalPresenter: ModalPresenter? { get set }
    var childCoordinators: [Coordinatable] { get set }
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinatable? { get set }

    func childDidFinish(child: Coordinatable)
    func goBack()
    init(navigationController: UINavigationController)
    func start()
}

class BaseCoordinator: NSObject,
                       Coordinatable {

    // TODO: should eventually die
    weak var modalPresenter: ModalPresenter? {
        get {
            guard let modalPresenter = presenter else {
                return parentCoordinator?.modalPresenter
            }

            return modalPresenter
        }
        set {
            presenter = newValue
        }
    }
    
    private weak var presenter: ModalPresenter?
    var parentCoordinator: Coordinatable?
    var childCoordinators: [Coordinatable] = []
    var navigationController: UINavigationController

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    init(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        let navigationController = RootNavigationController(rootViewController: viewController)
        self.navigationController = navigationController
    }

    func start() {
        let nvc = RootNavigationController()
        let coordinator: Coordinatable
        
        if let profile = UserManager.shared.profile,
           profile.email?.isEmpty == false,
           profile.status == .emailPending {
            coordinator = RegistrationCoordinator(navigationController: nvc)
        } else {
            coordinator = ProfileCoordinator(navigationController: nvc)
        }
        
        coordinator.start()
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        navigationController.show(nvc, sender: nil)
    }
    
    func showRegistration(shouldShowProfile: Bool = false) {
        let nvc = RootNavigationController()
        let coordinator = RegistrationCoordinator(navigationController: nvc)
        coordinator.start()
        coordinator.parentCoordinator = self
        
        if let vc = coordinator.navigationController.children.first(where: { $0 is RegistrationViewController }) as? RegistrationViewController {
            vc.dataStore?.shouldShowProfile = shouldShowProfile
        }
        
        if let vc = coordinator.navigationController.children.first(where: { $0 is RegistrationConfirmationViewController }) as? RegistrationConfirmationViewController {
            vc.dataStore?.shouldShowProfile = shouldShowProfile
        }
        
        childCoordinators.append(coordinator)
        navigationController.show(coordinator.navigationController, sender: nil)
    }
    
    func showSwap(currencies: [Currency], coreSystem: CoreSystem, keyStore: KeyStore) {
        upgradeAccountOrShowPopup(checkForKyc: true) { [weak self] showPopup in
            guard showPopup else { return }
            
            self?.openModally(coordinator: SwapCoordinator.self, scene: Scenes.Swap) { vc in
                vc?.dataStore?.currencies = currencies
                vc?.dataStore?.coreSystem = coreSystem
                vc?.dataStore?.keyStore = keyStore
                vc?.dataStore?.defaultCurrencyCode = Store.state.defaultCurrencyCode
                vc?.prepareData()
            }
        }
    }
    
    func showBuy() {
        upgradeAccountOrShowPopup(checkForKyc: true) { [unowned self] showPopup in
            guard showPopup else { return }
            
            ReservationWorker().execute(requestData: ReservationRequestData()) { [unowned self] result in
                switch result {
                case .success(let data):
                    guard let url = data.url,
                          let code = data.reservation else { return }
                    
                    guard UserDefaults.showBuyAlert else {
                        Store.perform(action: RootModalActions.Present(modal: .buy(url: url, reservationCode: code, currency: nil)))
                        return
                    }
                    
                    UserDefaults.showBuyAlert = false
                    let message = "Fabriik is providing Buy functionality through Wyre, a third-party API provider."
                    
                    let alert = UIAlertController(title: "Partnership note",
                                                  message: message,
                                                  preferredStyle: .alert)
                    let continueAction = UIAlertAction(title: L10n.Button.continueAction, style: .default) { _ in
                        Store.perform(action: RootModalActions.Present(modal: .buy(url: url, reservationCode: code, currency: nil)))
                    }
                    
                    alert.addAction(continueAction)
                    navigationController.present(alert, animated: true, completion: nil)

                case .failure(let error):
                    showMessage(with: error)
                    
                }
            }
        }
    }
    
    func showProfile() {
        upgradeAccountOrShowPopup(checkForKyc: false) { [weak self] _ in
            self?.openModally(coordinator: ProfileCoordinator.self, scene: Scenes.Profile)
        }
    }
    
    func showVerifications() {
        open(scene: Scenes.AccountVerification) { vc in
            vc.dataStore?.profile = UserManager.shared.profile
            vc.prepareData()
        }
    }
    
    func showVerificationsModally() {
        openModally(coordinator: KYCCoordinator.self, scene: Scenes.AccountVerification) { vc in
            vc?.dataStore?.profile = UserManager.shared.profile
            vc?.prepareData()
        }
    }
    
    func showDeleteProfileInfo(keyMaster: KeyStore) {
        let nvc = RootNavigationController()
        let coordinator = DeleteProfileInfoCoordinator(navigationController: nvc)
        coordinator.start(with: keyMaster)
        coordinator.parentCoordinator = self
        
        childCoordinators.append(coordinator)
        UIApplication.shared.activeWindow?.rootViewController?.presentedViewController?.present(coordinator.navigationController, animated: true)
        
        // TODO: Cleanup when everything is moved to Coordinators.
        // There are problems with showing this vc from both menu and profile menu.
        // Cannot get it work reliably. Navigation Controllers are messed up.
        // More hint: deleteAccountCallback inside ModalPresenter.
    }
    
    /// Determines whether the viewcontroller or navigation stack are being dismissed
    func goBack() {
        // if the same coordinator is used in a flow, we dont want to remove it from the parent
        guard navigationController.viewControllers.count < 1 else { return }

        guard navigationController.isBeingDismissed
                || navigationController.presentedViewController?.isBeingDismissed == true
                || navigationController.presentedViewController?.isMovingFromParent == true
                || parentCoordinator?.navigationController == navigationController
        else { return }
        parentCoordinator?.childDidFinish(child: self)
    }

    /// Remove the child coordinator from the stack after iit finnished its flow
    func childDidFinish(child: Coordinatable) {
        childCoordinators.removeAll(where: { $0 === child })
    }
    
    // only call from coordinator subclasses
    func open<T: BaseControllable>(scene: T.Type,
                                   presentationStyle: UIModalPresentationStyle = .fullScreen,
                                   configure: ((T) -> Void)? = nil) {
        let controller = T()
        controller.coordinator = (self as? T.CoordinatorType)
        configure?(controller)
        navigationController.modalPresentationStyle = presentationStyle
        navigationController.show(controller, sender: nil)
    }

    // only call from coordinator subclasses
    func set<C: BaseCoordinator,
             VC: BaseControllable>(coordinator: C.Type,
                                   scene: VC.Type,
                                   presentationStyle: UIModalPresentationStyle = .fullScreen,
                                   configure: ((VC?) -> Void)? = nil) {
        let controller = VC()
        let coordinator = C(navigationController: navigationController)
        controller.coordinator = coordinator as? VC.CoordinatorType
        configure?(controller)
        
        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        navigationController.setViewControllers([controller], animated: true)
    }
    
    // only call from coordinator subclasses
    func openModally<C: BaseCoordinator,
                     VC: BaseControllable>(coordinator: C.Type,
                                           scene: VC.Type,
                                           presentationStyle: UIModalPresentationStyle = .fullScreen,
                                           configure: ((VC?) -> Void)? = nil) {
        let controller = VC()
        let nvc = RootNavigationController(rootViewController: controller)
        nvc.modalPresentationStyle = presentationStyle
        nvc.modalPresentationCapturesStatusBarAppearance = true
        
        let coordinator = C(navigationController: nvc)
        controller.coordinator = coordinator as? VC.CoordinatorType
        configure?(controller)

        coordinator.parentCoordinator = self
        childCoordinators.append(coordinator)
        
        navigationController.show(nvc, sender: nil)
    }
    
    // It prepares the next KYC coordinator OR returns true.
    // In which case we show 3rd party popup or continue to Buy/Swap.
    func upgradeAccountOrShowPopup(checkForKyc: Bool, completion: ((Bool) -> Void)?) {
        let nvc = RootNavigationController()
        var coordinator: Coordinatable?
        
        // TODO: If this logic passes QA, then unify the code in other places like "ApplicationController, HomeScreenViewController" and etc.
        UserManager.shared.refresh { [unowned self] result in
            switch result {
            case .success(let profile):
                let roles = profile.roles
                let status = profile.status
                let canBuyTrade = status == .levelOne || status == .levelTwo(.levelTwo)
                
                if roles.contains(.unverified) || roles.isEmpty == true ||
                    status == .emailPending || status == .none {
                    coordinator = RegistrationCoordinator(navigationController: nvc)
                    
                } else if roles.contains(.customer) || canBuyTrade {
                    if checkForKyc && canBuyTrade == false {
                        coordinator = KYCCoordinator(navigationController: nvc)
                        
                    } else {
                        completion?(true)
                        
                        return
                        
                    }
                    
                }
                
            case .failure(let error):
                guard error as? NetworkingError == .sessionExpired
                        || error as? NetworkingError == .parameterMissing else {
                    completion?(false)
                    return
                }
                
                coordinator = RegistrationCoordinator(navigationController: RootNavigationController())
                
            default:
                completion?(true)
                
                return
            }
            
            guard let coordinator = coordinator else {
                completion?(false)
                
                return
            }
            
            coordinator.start()
            coordinator.parentCoordinator = self
            childCoordinators.append(coordinator)
            navigationController.show(coordinator.navigationController, sender: nil)
            
            completion?(false)
        }
    }

    func showMessage(with error: Error? = nil, model: InfoViewModel? = nil, configuration: InfoViewConfiguration? = nil) {
        hideOverlay()
        LoadingView.hide()
        
        guard (error as? NetworkingError) != .sessionExpired else {
            UserDefaults.emailConfirmed = false
            openModally(coordinator: RegistrationCoordinator.self, scene: Scenes.RegistrationConfirmation)
            return
        }
        
        guard let model = model, let configuration = configuration else { return }
        
        let notification = FEInfoView()
        notification.setupCustomMargins(all: .large)
        notification.configure(with: configuration)
        notification.setup(with: model)
        guard let superview = navigationController.topViewController?.view else {
            return
        }
        superview.addSubview(notification)
        notification.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(Margins.medium.rawValue)
            make.trailing.equalToSuperview().offset(-Margins.medium.rawValue)
        }
        notification.layoutIfNeeded()
        notification.alpha = 0
            
        UIView.animate(withDuration: Presets.Animation.duration) {
            notification.alpha = 1
        }
    }
    
    func hideMessage(_ view: UIView) {}

    func goBack(completion: (() -> Void)? = nil) {
        guard parentCoordinator != nil,
              parentCoordinator?.navigationController != navigationController else {
            navigationController.popViewController(animated: true)
            return
        }
        navigationController.dismiss(animated: true) {
            completion?()
        }
        parentCoordinator?.childDidFinish(child: self)
    }
    
    func showUnderConstruction(_ feat: String) {
        // TODO: navigate on
        showPopup(with: .init(title: .text("Under construction"),
                              body: "The \(feat.uppercased()) functionality is being developed for You by the awesome Fabriik team. Stay tuned!"))
    }
    
    func showOverlay(with viewModel: TransparentViewModel, completion: (() -> Void)? = nil) {
        guard let parent = navigationController.view
        else { return }
        
        let view = TransparentView()
        view.configure(with: .init())
        view.setup(with: viewModel)
        view.didHide = completion
        
        parent.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        view.show()
        parent.bringSubviewToFront(view)
    }
    
    func hideOverlay() {
        guard let view = navigationController.view.subviews.first(where: { $0 is TransparentView }) as? TransparentView else { return }
        view.hide()
    }
    
    func showPopup<V: ViewProtocol & UIView>(with config: WrapperPopupConfiguration<V.C>?,
                                             viewModel: WrapperPopupViewModel<V.VM>,
                                             confirmedCallback: @escaping (() -> Void)) -> WrapperPopupView<V>? {
        guard let superview = navigationController.view else { return nil }
        
        let view = WrapperPopupView<V>()
        view.configure(with: config)
        view.setup(with: viewModel)
        view.confirmCallback = confirmedCallback
        
        superview.addSubview(view)
        superview.bringSubviewToFront(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        view.alpha = 0
            
        UIView.animate(withDuration: Presets.Animation.duration) {
            view.alpha = 1
        }
        
        return view
    }
}
