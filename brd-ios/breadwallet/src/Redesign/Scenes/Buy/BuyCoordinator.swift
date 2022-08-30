//
//  BuyCoordinator.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

class BuyCoordinator: BaseCoordinator, BuyRoutes, BillingAddressRoutes, OrderPreviewRoutes, AssetSelectionDisplayable {
    // MARK: - BuyRoutes
    
    override func start() {
        open(scene: Scenes.Buy)
    }
    
    func reloadBuy(card: PaymentCard) {
        let buyVC = navigationController.children.first(where: { $0 is BuyViewController }) as? BuyViewController
        buyVC?.dataStore?.paymentCard = card
        buyVC?.prepareData()
    }
    
    func showBillingAddress(addCardDataStore: AddCardStore?) {
        open(scene: Scenes.BillingAddress) { vc in
            vc.interactor?.dataStore?.addCardDataStore = addCardDataStore
            vc.prepareData()
        }
    }
    
    func showThreeDSecure(url: URL) {
        let webViewController = SimpleWebViewController(url: url)
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        webViewController.setup(with: .init(title: "3D Secure")) // TODO: Localize
        webViewController.didDismiss = { [weak self] in
            (self?.navigationController.topViewController as? DataPresentable)?.prepareData()
            navController.dismiss(animated: true)
        }
        
        navigationController.present(navController, animated: true)
    }
    
    func showSuccess(paymentReference: String) {
        open(scene: Scenes.Success) { vc in
            vc.dataStore?.itemId = paymentReference
            
            vc.firstCallback = { [weak self] in
                self?.navigationController.dismiss(animated: true)
            }
            
            vc.secondCallback = { [weak self] in
                self?.showSwapDetails(exchangeId: paymentReference)
            }
        }
    }
    
    func showFailure() {
        open(scene: Scenes.Failure) { vc in
            vc.failure = FailureReason.buy
            vc.firstCallback = { [weak self] in
                self?.navigationController.popToRootViewController(animated: true) { [weak self] in
                    (self?.navigationController.topViewController as? BuyViewController)?.interactor?.getPaymentCards(viewAction: .init())
                }
            }
            
            vc.secondCallback = { [weak self] in
                self?.showSupport()
            }
        }
    }
    
    func showTimeout() {
        open(scene: Scenes.Timeout) { vc in
            vc.navigationItem.setHidesBackButton(true, animated: false)
            
            vc.firstCallback = { [weak self] in
                self?.navigationController.popToRootViewController(animated: true) { [weak self] in
                    (self?.navigationController.topViewController as? BuyViewController)?.interactor?.getData(viewAction: .init())
                }
            }
        }
    }
    
    func showTermsAndConditions(url: URL) {
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: "Terms and Conditions"))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    func showSupport() {
        guard let url = URL(string: C.supportLink) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: "Support"))
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    func showSwapDetails(exchangeId: String) {
        open(scene: SwapDetailsViewController.self) { vc in
            vc.navigationItem.hidesBackButton = true
            vc.dataStore?.itemId = exchangeId
            vc.dataStore?.transactionType = .buyTransaction
            vc.dataStore?.sceneTitle = "Purchase details" // TODO: Localize.
            vc.prepareData()
        }
    }
    
    func showCardSelector(cards: [PaymentCard], selected: ((PaymentCard?) -> Void)?) {
        if cards.isEmpty == true {
            open(scene: Scenes.AddCard)
        } else {
            open(scene: Scenes.CardSelection) { [weak self] vc in
                vc.dataStore?.isAddingEnabled = true
                vc.dataStore?.items = cards
                vc.prepareData()
                
                vc.itemSelected = { item in
                    selected?(item as? PaymentCard)
                    self?.popFlow()
                }
                
                vc.addItemTapped = { [weak self] in
                    self?.open(scene: Scenes.AddCard)
                }
            }
        }
    }
    
    func showCountrySelector(countries: [Country], selected: ((Country?) -> Void)?) {
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.ItemSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = countries
            vc?.itemSelected = { item in
                selected?(item as? Country)
            }
            vc?.prepareData()
        }
    }
    
    func showPinInput(keyStore: KeyStore?, callback: ((_ pin: String?) -> Void)?) {
        guard let keyStore = keyStore else {
            fatalError("KeyStore error.")
        }
        
        let vc = LoginViewController(for: .confirmation,
                                     keyMaster: keyStore,
                                     shouldDisableBiometrics: true)
        
        let nvc = RootNavigationController(rootViewController: vc)
        vc.confirmationCallback = { [weak self] pin in
            if pin == nil {
                self?.showMessage(with: BuyErrors.pinConfirmation)
            }
            callback?(pin)
            nvc.dismiss(animated: true)
        }
        nvc.modalPresentationStyle = .fullScreen
        navigationController.show(nvc, sender: nil)
    }
    
    func showInfo(from: String, to: String, exchangeId: String) {
        
    }
    
    func showOrderPreview(coreSystem: CoreSystem?,
                          keyStore: KeyStore?,
                          to: Amount?,
                          from: Decimal?,
                          card: PaymentCard?,
                          quote: Quote?,
                          networkFee: Amount?) {
        open(scene: Scenes.OrderPreview) { vc in
            vc.dataStore?.coreSystem = coreSystem
            vc.dataStore?.keyStore = keyStore
            vc.dataStore?.from = from
            vc.dataStore?.to = to
            vc.dataStore?.card = card
            vc.dataStore?.quote = quote
            vc.dataStore?.networkFee = networkFee
            vc.prepareData()
        }
    }
    
    // MARK: - Aditional helpers
    
    func dismissFlow() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(child: self)
    }
    
    @objc func popFlow() {
        if navigationController.children.count == 1 {
            dismissFlow()
        }
        
        navigationController.popToRootViewController(animated: true)
    }
}

extension BuyCoordinator {
    func showMonthYearPicker(model: [[String]]) {
        guard let viewController = navigationController.children.last(where: { $0 is AddCardViewController }) as? AddCardViewController else { return }
        
        PickerViewViewController.show(on: viewController,
                                      sourceView: viewController.view,
                                      title: nil,
                                      values: model,
                                      selection: .init(primaryRow: 0, secondaryRow: 0)) { _, _, index, _ in
            viewController.interactor?.cardInfoSet(viewAction: .init(expirationDateIndex: index))
        }
    }
}
