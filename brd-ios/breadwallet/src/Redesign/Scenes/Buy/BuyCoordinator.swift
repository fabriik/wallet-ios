//
//  BuyCoordinator.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

class BuyCoordinator: BaseCoordinator, BuyRoutes, BillingAddressRoutes {
    // MARK: - BuyRoutes

    override func start() {
        open(scene: Scenes.Buy)
    }
    
    func reloadBuy(card: PaymentCard) {
        let buyVC = navigationController.children.first(where: { $0 is BuyViewController }) as? BuyViewController
        buyVC?.dataStore?.paymentCard = card
        buyVC?.prepareData()
    }
    
    func showBillingAddress() {
        open(scene: Scenes.BillingAddress)
    }
    
    func show3DSecure(url: String) {
        guard let url = URL(string: url) else { return }
        let webViewController = SimpleWebViewController(url: url)
        webViewController.setup(with: .init(title: "3D Secure"))
        webViewController.didDismiss = { [weak self] in
            let vc = self?.navigationController.children.first(where: { $0 is AddCardViewController }) as? AddCardViewController
            vc?.interactor?.check3DSecureStatus(viewAction: .init())
        }
        let navController = RootNavigationController(rootViewController: webViewController)
        webViewController.setAsNonDismissableModal()
        
        navigationController.present(navController, animated: true)
    }
    
    func showAssetSelector(currencies: [Currency]?, selected: ((Any?) -> Void)?) {
        let data: [AssetViewModel]? = currencies?.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code,
                                  topRightText: HomeScreenAssetViewModel(currency: $0).tokenBalance,
                                  bottomRightText: HomeScreenAssetViewModel(currency: $0).fiatBalance,
                                  isDisabled: false)
        }
        
        let sortedCurrencies = data?.sorted { !$0.isDisabled && $1.isDisabled }
        
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.AssetSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = sortedCurrencies
            vc?.itemSelected = selected
            vc?.prepareData()
        }
    }
    
    func showCardSelector(cards: [PaymentCard], selected: ((PaymentCard?) -> Void)?) {
        if cards.isEmpty == true {
            open(scene: Scenes.AddCard)
        } else {
            open(scene: Scenes.CardSelection) { [weak self] vc in
                vc.dataStore?.isAddingEnabled = true
                vc.dataStore?.items = cards
                vc.itemSelected = { item in
                    selected?(item as? PaymentCard)
                    self?.popFlow()
                }
                vc.prepareData()
                
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
    
    func showPinInput(callback: ((_ pin: String?) -> Void)?) {
        
    }
    
    func showInfo(from: String, to: String, exchangeId: String) {
        
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
