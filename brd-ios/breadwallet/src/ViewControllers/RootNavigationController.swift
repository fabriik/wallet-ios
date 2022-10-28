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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNormalNavigationBar()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let backgroundColor: UIColor
        let tintColor: UIColor
        
        switch viewController {
        case is AccountViewController:
            backgroundColor = .clear
            tintColor = LightColors.Text.three
            
        case is KYCCameraViewController:
            backgroundColor = .black
            tintColor = LightColors.Background.one
            
        case is HomeScreenViewController,
            is OnboardingViewController:
            backgroundColor = .clear
            tintColor = LightColors.Background.two
            
        case is ManageWalletsViewController,
            is AddWalletsViewController,
            is RecoveryKeyIntroViewController,
            is EnterPhraseViewController,
            is AboutViewController,
            is UpdatePinViewController,
            is LoginViewController:
            backgroundColor = LightColors.Background.cards
            tintColor = LightColors.Text.three
            
        default:
            backgroundColor = LightColors.Background.two
            tintColor = LightColors.Text.three
        }
        
        let item = SimpleBackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        
        setNormalNavigationBar(normalBackgroundColor: backgroundColor,
                               scrollBackgroundColor: backgroundColor,
                               tintColor: tintColor)
    }
    
    func setNormalNavigationBar(normalBackgroundColor: UIColor = .clear,
                                scrollBackgroundColor: UIColor = .clear,
                                tintColor: UIColor = LightColors.Text.one) {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.Title.six, NSAttributedString.Key.foregroundColor: tintColor
        ]
        
        let normalAppearance = UINavigationBarAppearance()
        normalAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        normalAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        normalAppearance.configureWithOpaqueBackground()
        normalAppearance.backgroundColor = normalBackgroundColor
        normalAppearance.shadowColor = nil
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.setBackIndicatorImage(UIImage(named: "back"), transitionMaskImage: UIImage(named: "back"))
        scrollAppearance.titleTextAttributes = navigationBar.titleTextAttributes ?? [:]
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.backgroundColor = scrollBackgroundColor
        scrollAppearance.shadowColor = nil
        
        navigationBar.scrollEdgeAppearance = normalAppearance
        navigationBar.standardAppearance = scrollAppearance
        navigationBar.compactAppearance = scrollAppearance
        
        navigationBar.tintColor = tintColor
        navigationBar.prefersLargeTitles = false
    }
}
