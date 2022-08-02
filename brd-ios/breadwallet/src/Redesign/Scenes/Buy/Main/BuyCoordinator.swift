//
//  BuyCoordinator.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

class BuyCoordinator: BaseCoordinator, BuyRoutes {
    // MARK: - BuyRoutes

    // MARK: - Aditional helpers
    override func start() {
        open(scene: Scenes.Buy)
    }
    
    func showAssetSelector(currencies: [Currency]?, selected: ((Any?) -> Void)?) {
        openModally(coordinator: SwapCoordinator.self,
                    scene: Scenes.AssetSelection) { vc in
            vc?.itemSelected = selected
            vc?.dataStore?.currencies = currencies ?? []
            vc?.prepareData()
        }
    }
    
    // TODO: pass card model
    func showCardSelector(selected: ((Any?) -> Void)?) {
        selected?("15449324923423")
    }
    
    func showPinInput(callback: ((_ pin: String?) -> Void)?) {
        
    }
    
    func showInfo(from: String, to: String, exchangeId: String) {
        
    }
}
