//
//  VerifyPinViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-01-17.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication

enum PinAuthenticationType {
    case unlocking
    case transactions
    case recoveryKey
}

class VerifyPinViewController: UIViewController {

    init(bodyText: String,
         pinLength: Int,
         walletAuthenticator: WalletAuthenticator,
         pinAuthenticationType: PinAuthenticationType,
         success: @escaping (String) -> Void) {
        self.bodyText = bodyText
        self.success = success
        self.pinLength = pinLength
        self.pinAuthenticationType = pinAuthenticationType
        self.pinView = PinView(style: .verify, length: pinLength)
        self.walletAuthenticator = walletAuthenticator
        
        let showBiometrics = VerifyPinViewController.shouldShowBiometricsOnPinPad(for: pinAuthenticationType, authenticator: walletAuthenticator)
        self.pinPad = PinPadViewController(style: .white,
                                           keyboardType: .pinPad,
                                           maxDigits: 0,
                                           shouldShowBiometrics: showBiometrics)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    private static func shouldShowBiometricsOnPinPad(for authenticationType: PinAuthenticationType,
                                                     authenticator: WalletAuthenticator) -> Bool {
        switch authenticationType {
        case .transactions:
            return authenticator.isBiometricsEnabledForTransactions
        case .unlocking:
            return authenticator.isBiometricsEnabledForUnlocking
        default:
            return false
        }
    }
    
    var didCancel: (() -> Void)?
    let blurView = UIVisualEffectView()
    let effect = UIBlurEffect(style: .dark)
    let contentBox = UIView()
    private var pinAuthenticationType: PinAuthenticationType = .unlocking
    private let success: (String) -> Void
    private let pinPad: PinPadViewController
    private let titleLabel = UILabel.wrapping(font: Theme.h2Title, color: Theme.primaryText)
    private let body = UILabel.wrapping(font: Theme.body1, color: Theme.secondaryText)
    private let pinView: PinView
    private let bodyText: String
    private let pinLength: Int
    private let walletAuthenticator: WalletAuthenticator
    
    override func viewDidLoad() {
        addSubviews()
        addConstraints()
        setupSubviews()
        setUpBiometricsAuthentication()
        setupBackButton()
    }

    private func addSubviews() {
        view.addSubview(contentBox)
        
        contentBox.addSubview(titleLabel)
        contentBox.addSubview(body)
        contentBox.addSubview(pinView)
        addChildViewController(pinPad, layout: {
            pinPad.view.constrain([
                pinPad.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pinPad.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: LAContext.biometricType() == .face ? -C.padding[3] : 0.0),
                pinPad.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pinPad.view.heightAnchor.constraint(equalToConstant: pinPad.height) ])
        })
    }

    private func addConstraints() {
        contentBox.constrain([
            contentBox.topAnchor.constraint(equalTo: view.topAnchor, constant: C.padding[20]),
            contentBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentBox.widthAnchor.constraint(equalToConstant: 256.0) ])
        titleLabel.constrainTopCorners(sidePadding: C.padding[2], topPadding: C.padding[2])
        body.constrain([
            body.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            body.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: C.padding[2]),
            body.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)])
        pinView.constrain([
            pinView.topAnchor.constraint(equalTo: body.bottomAnchor, constant: C.padding[10]),
            pinView.centerXAnchor.constraint(equalTo: body.centerXAnchor),
            pinView.widthAnchor.constraint(equalToConstant: pinView.width),
            pinView.heightAnchor.constraint(equalToConstant: pinView.itemSize),
            pinView.bottomAnchor.constraint(equalTo: contentBox.bottomAnchor, constant: -C.padding[2])])
    }

    private func setupSubviews() {
        view.backgroundColor = .white
        
        titleLabel.text = L10n.VerifyPin.title
        titleLabel.textAlignment = .center
        
        body.text = bodyText
        body.numberOfLines = 0
        body.lineBreakMode = .byWordWrapping
        body.textAlignment = .center
        
        pinPad.ouputDidUpdate = { [weak self] output in
            guard let myself = self else { return }
            let attemptLength = output.utf8.count
            myself.pinView.fill(attemptLength)
            myself.pinPad.isAppendingDisabled = attemptLength < myself.pinLength ? false : true
            if attemptLength == myself.pinLength {
                if myself.walletAuthenticator.authenticate(withPin: output) {
                    myself.dismiss(animated: true, completion: {
                        myself.success(output)
                    })
                } else {
                    myself.authenticationFailed()
                }
            }
        }
    }
    
    func setupBackButton() {
        let back = UIBarButtonItem(image: UIImage(named: "BackArrowWhite"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(backButtonPressed))
        back.tintColor = Theme.blueBackground
        navigationItem.leftBarButtonItem = back
    }

    private func setUpBiometricsAuthentication() {
        if VerifyPinViewController.shouldShowBiometricsOnPinPad(for: self.pinAuthenticationType, authenticator: self.walletAuthenticator) {
            self.pinPad.didTapBiometrics = { [weak self] in
                guard let self = self else { return }
                self.walletAuthenticator.authenticate(withBiometricsPrompt: "biometrics", completion: { (result) in
                    if result == .success {
                        self.success("")
                    }
                })
            }
        }
    }
    
    private func authenticationFailed() {
        pinPad.view.isUserInteractionEnabled = false
        pinView.shake { [weak self] in
            self?.pinPad.view.isUserInteractionEnabled = true
            self?.pinView.fill(0)
            self?.lockIfNeeded()
        }
        pinPad.clear()
    }

    private func lockIfNeeded() {
        guard walletAuthenticator.walletIsDisabled else { return }
        dismiss(animated: true, completion: {
            Store.perform(action: RequireLogin())
        })
    }
    
    @objc func backButtonPressed() {
        didCancel?()
        dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
