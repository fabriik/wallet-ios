//
//  RootNavigationController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-12-05.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let vc = topViewController else { return .default }
        return vc.preferredStatusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setNormalNavigationBar()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backgroundColor: UIColor
        let tintColor: UIColor
        
        switch viewController {
        case is AccountViewController,
            is HomeScreenViewController,
            is KYCCameraViewController,
            is OnboardingViewController:
            backgroundColor = LightColors.Background.two
            tintColor = LightColors.Background.two
            
        case is ManageWalletsViewController,
            is AddWalletsViewController,
            is RecoveryKeyIntroViewController,
            is EnterPhraseViewController:
            backgroundColor = LightColors.Background.cards
            tintColor = LightColors.Text.three
            
        default:
            backgroundColor = LightColors.Background.two
            tintColor = LightColors.Text.three
        }
        
        setNormalNavigationBar(normalBackgroundColor: backgroundColor, tintColor: tintColor)
        let item = SimpleBackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    func setNormalNavigationBar(normalBackgroundColor: UIColor = .clear,
                                scrollBackgroundColor: UIColor = .clear,
                                tintColor: UIColor = LightColors.Text.one) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.Title.six, NSAttributedString.Key.foregroundColor: tintColor
        ]
        
        let normalAppearance = UINavigationBarAppearance()
        normalAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        normalAppearance.configureWithOpaqueBackground()
        normalAppearance.backgroundColor = normalBackgroundColor
        normalAppearance.shadowColor = nil
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.backgroundColor = normalBackgroundColor
        scrollAppearance.shadowColor = nil
        
        navigationBar.scrollEdgeAppearance = normalAppearance
        navigationBar.standardAppearance = scrollAppearance
        navigationBar.compactAppearance = scrollAppearance
        
        navigationBar.tintColor = tintColor
        navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = .clear
    }
}
