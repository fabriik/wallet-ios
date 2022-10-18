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
        if viewController is AccountViewController ||
            viewController is HomeScreenViewController ||
            viewController is KYCCameraViewController ||
            viewController is OnboardingViewController {
            setNormalNavigationBar(tintColor: LightColors.Contrast.two)
        } else {
            setNormalNavigationBar(normalBackgroundColor: LightColors.Contrast.two)
        }
        
        let item = SimpleBackBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    func setNormalNavigationBar(normalBackgroundColor: UIColor = .clear,
                                scrollBackgroundColor: UIColor = .clear,
                                tintColor: UIColor = LightColors.Text.one) {
        let normalAppearance = UINavigationBarAppearance()
        normalAppearance.configureWithOpaqueBackground()
        normalAppearance.backgroundColor = normalBackgroundColor
        normalAppearance.shadowColor = nil
        
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.configureWithTransparentBackground()
        scrollAppearance.backgroundColor = normalBackgroundColor
        scrollAppearance.shadowColor = nil
        
        navigationBar.scrollEdgeAppearance = normalAppearance
        navigationBar.standardAppearance = scrollAppearance
        navigationBar.compactAppearance = scrollAppearance
        
        navigationBar.tintColor = tintColor
        navigationBar.prefersLargeTitles = false
        
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: Fonts.Title.six
        ]
        
        view.backgroundColor = .clear
    }
}
