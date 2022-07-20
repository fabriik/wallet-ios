// 
//  SwapCoordinator.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class SwapCoordinator: BaseCoordinator, SwapRoutes {
    // MARK: - ProfileRoutes
    
    override func start() {
        open(scene: Scenes.Swap)
    }
    
    override func goBack() {
        parentCoordinator?.childDidFinish(child: self)
        navigationController.dismiss(animated: true)
    }
    
    func showAssetSelector(currencies: [Currency]?, assets: [String]?, selected: ((Any?) -> Void)?) {
        openModally(coordinator: SwapCoordinator.self, scene: Scenes.AssetSelection) { vc in
            vc?.itemSelected = selected
            vc?.dataStore?.supportedCurrencies = assets ?? []
            vc?.dataStore?.currencies = currencies ?? []
            vc?.prepareData()
        }
    }
    
    func showConfirm() {
        // TODO: pass actual data
        guard let superview = navigationController.view else {
            return
        }
        let view = WrapperPopupView<SwapConfirmationView>()
        superview.addSubview(view)
        superview.bringSubviewToFront(view)
        
        view.configure(with: WrapperPopupConfiguration())

        view.setup(with: .init(title: .text("Confirmation"), trailing: .init(image: "close"), buttons: [
            .init(title: "Confirm"),
            .init(title: "Cancel")
        ]))
        
        view.callbacks = [
            { print("confirm tapped!") },
            { print("cancel tapped!") }
        ]
        
        view.wrappedView.setup(with: .init(from: .init(title: .text("From"), value: .text("50 BSV ($2,859.00)")),
                                   to: .init(title: .text("To"), value: .text("0.00000095 BTC ($2,857.48)")),
                                   rate: .init(title: .text("Rate"), value: .text("1 BSV = 0.0000333 BTC")),
                                   sendingFee: .init(title: .text("Sending Network fee\n"), value: .text("0.00023546 BSV \n($0.01)")),
                                   receivingFee: .init(title: .text("Receiving fee\n"), value: .text("0.00023546 BSV\n($0.01)")),
                                   totalCost: .init(title: .text("Total cost:"), value: .text("50 BSV"))))
        view.wrappedView.configure(with: SwapConfimationConfiguration())
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.layoutIfNeeded()
        view.alpha = 0
            
        UIView.animate(withDuration: Presets.Animation.duration) {
            view.alpha = 1
        }
    }
    
    // MARK: - Aditional helpers
    
}
