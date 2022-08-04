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

    // MARK: - Aditional helpers
    override func start() {
        open(scene: Scenes.Buy)
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
                    scene: Scenes.AssetSelection) { vc in
            vc?.dataStore?.items = sortedCurrencies
            vc?.itemSelected = selected
            vc?.prepareData()
        }
    }
    
    // TODO: pass card model
    func showCardSelector(selected: ((PaymentCard?) -> Void)?) {
        let items: [PaymentCard] = [
            .init(type: "VISA", number: "999-999-99-9", expiration: "5/26", image: nil),
            .init(type: "AMEX", number: "239-4232-11-0", expiration: "1/23", image: nil),
            .init(type: "MASTERCARD", number: "5509-193-1928-25", expiration: "7/33", image: nil)
        ]
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.CardSelection) { vc in
            vc?.dataStore?.isAddingEnabled = true
            vc?.dataStore?.items = items
            vc?.itemSelected = { item in
                selected?(item as? PaymentCard)
            }
            vc?.prepareData()
            
            vc?.addItemTapped = { [weak self] in
                vc?.dismiss(animated: true, completion: {
                    self?.showUnderConstruction("Add new card flow")
                })
            }
        }
    }
    
    func showCountrySelector(selected: ((Country?) -> Void)?) {
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.ItemSelection) { vc in
            vc?.itemSelected = { item in
                selected?(item as? Country)
            }
        }
    }
    
    func showPinInput(callback: ((_ pin: String?) -> Void)?) {
        
    }
    
    func showInfo(from: String, to: String, exchangeId: String) {
        
    }
}

struct PaymentCard: ItemSelectable {
    // TODO: add w/e is needed
    var type: String?
    var number: String?
    var expiration: String?
    var image: UIImage?
    
    var displayName: String? { return number }
    var displayImage: ImageViewModel? {
        guard let image = image else {
            return .imageName("close")
        }
        return .image(image)
    }
}

extension BuyCoordinator {
    func showMonthYearPicker(model: AddCardModels.MonthsYears) {
        guard let viewController = navigationController.children.last(where: { $0 is AddCardViewController }) as? AddCardViewController else { return }
        
        PickerViewViewController.show(on: viewController,
                                      sourceView: viewController.view,
                                      title: nil,
                                      values: [model.months, model.years],
                                      selection: .init(primaryRow: 0, secondaryRow: 0)) { _, _, index, _ in
            viewController.interactor?.cardExpDateSet(viewAction: .init(index: index))
        }
    }
}
