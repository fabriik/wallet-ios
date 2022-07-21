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
    
    func showPinInput(callback: ((_ didPass: Bool) -> Void)?) {
        guard let keyStore = try? KeyStore.create() else { return }
        let vc = LoginViewController(for: .confirmation,
                                     keyMaster: keyStore,
                                     shouldDisableBiometrics: false)
        
        let nvc = RootNavigationController(rootViewController: vc)
        vc.confirmationCallback = { confirmed in
            callback?(confirmed)
            nvc.dismiss(animated: true)
        }
        nvc.modalPresentationStyle = .fullScreen
        navigationController.show(nvc, sender: nil)
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
    
    // MARK: - Aditional helpers
    
}
