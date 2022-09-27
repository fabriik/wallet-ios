//
//  BaseRecoveryKeyViewController.swift
//  breadwallet
//
//  Created by Ray Vander Veen on 2019-04-15.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import UIKit

class BaseRecoveryKeyViewController: UIViewController {
    
    enum CloseButtonStyle {
        case close
        case skip
    }
    
    let continueButtonHeight: CGFloat = 48
    
    var closeButtonStyle: CloseButtonStyle {
        return .close
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func constrainContinueButton(_ button: BRDButton) {
        button.constrain([
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: C.padding[2]),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -C.padding[2]),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -C.padding[2]),
            button.heightAnchor.constraint(equalToConstant: continueButtonHeight)
            ])
    }
    
    @objc func onBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onCloseButton() {
        // Override in subclasses if appropriate.
    }

    func showCloseButton() {
        switch closeButtonStyle {
        case .close:
            let close = UIBarButtonItem(image: UIImage(named: "CloseModern"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(onCloseButton))
            close.tintColor = Theme.blueBackground
            navigationItem.rightBarButtonItem = close

        case .skip:
            let skip = UIBarButtonItem(title: L10n.Button.skip,
                                       style: .plain,
                                       target: self,
                                       action: #selector(onCloseButton))
            skip.tintColor = Theme.tertiaryText
            let fontAttributes = [NSAttributedString.Key.font: Theme.body2]
            skip.setTitleTextAttributes(fontAttributes, for: .normal)
            skip.setTitleTextAttributes(fontAttributes, for: .highlighted)
            navigationItem.rightBarButtonItem = skip
        }
    }
    
    func showBackButton() {
        let back = UIBarButtonItem(image: UIImage(named: "BackArrowWhite"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(onBackButton))
        back.tintColor = Theme.blueBackground
        navigationItem.leftBarButtonItem = back
    }
    
    func hideBackButton() {
        navigationItem.leftBarButtonItem = nil
    }
}
