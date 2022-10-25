//
//  ConfirmationViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-07-28.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import LocalAuthentication

class ConfirmationViewController: UIViewController, ContentBoxPresenter {
    init(amount: Amount, fee: Amount, displayFeeLevel: FeeLevel, address: String, currency: Currency,
         resolvedAddress: ResolvedAddress? = nil, shouldShowMaskView: Bool, isStake: Bool = false) {
        self.amount = amount
        self.feeAmount = fee
        self.displayFeeLevel = displayFeeLevel
        self.addressText = address
        self.currency = currency
        self.resolvedAddress = resolvedAddress
        self.isStake = isStake
        
        super.init(nibName: nil, bundle: nil)
        
        transitionDelegate.shouldShowMaskView = shouldShowMaskView
        transitioningDelegate = transitionDelegate
        modalPresentationStyle = .overFullScreen
        modalPresentationCapturesStatusBarAppearance = true
    }
    
    private let transitionDelegate = PinTransitioningDelegate()
    private let amount: Amount
    private let feeAmount: Amount
    private let displayFeeLevel: FeeLevel
    private let addressText: String
    private let currency: Currency
    private let resolvedAddress: ResolvedAddress?
    private var isStake: Bool
    
    let contentBox = UIView(color: .white)
    let blurView = UIVisualEffectView()
    let effect = UIBlurEffect(style: .dark)
    
    var successCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?
    
    private lazy var header: ModalHeaderView = {
        let view = ModalHeaderView(title: L10n.Confirmation.title)
        return view
    }()
    
    private lazy var cancel: FEButton = {
        let view = FEButton()
        view.configure(with: Presets.Button.secondary)
        view.setup(with: .init(title: L10n.Button.cancel))
        return view
    }()
    
    private lazy var sendButton: FEButton = {
        let view = FEButton()
        view.configure(with: Presets.Button.primary)
        view.setup(with: .init(title: L10n.Confirmation.send))
        return view
    }()
    
    private lazy var payLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var toLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private lazy var amountLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.one, textColor: LightColors.Text.two))
        return view
    }()
    
    private lazy var address: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Body.one, textColor: LightColors.Text.two, lineBreakMode: .byTruncatingMiddle))
        return view
    }()
    
    private let processingTime = UILabel.wrapping(font: .customBody(size: 14.0), color: .grayTextTint)
    private let sendLabel = UILabel(font: .customBody(size: 14.0), color: .darkText)
    private let feeLabel = UILabel(font: .customBody(size: 14.0), color: .darkText)
    
    private lazy var totalLabel: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        view.setup(with: .text(L10n.Confirmation.totalLabel))
        return view
    }()
    
    private let send = UILabel(font: .customBody(size: 14.0), color: .darkText)
    private let fee = UILabel(font: .customBody(size: 14.0), color: .darkText)
    private lazy var total: FELabel = {
        let view = FELabel()
        view.configure(with: .init(font: Fonts.Subtitle.two, textColor: LightColors.Text.one))
        return view
    }()
    
    private let resolvedAddressTitle = ResolvedAddressLabel()
    private let resolvedAddressLabel = UILabel(font: .customBody(size: 16.0), color: .darkText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        addConstraints()
        setInitialData()
    }
    
    private func addSubviews() {
        view.addSubview(contentBox)
        contentBox.addSubview(header)
        contentBox.addSubview(payLabel)
        contentBox.addSubview(toLabel)
        contentBox.addSubview(amountLabel)
        contentBox.addSubview(address)
        contentBox.addSubview(resolvedAddressTitle)
        contentBox.addSubview(resolvedAddressLabel)
        contentBox.addSubview(processingTime)
        contentBox.addSubview(sendLabel)
        contentBox.addSubview(feeLabel)
        contentBox.addSubview(totalLabel)
        contentBox.addSubview(send)
        contentBox.addSubview(fee)
        contentBox.addSubview(total)
        contentBox.addSubview(cancel)
        contentBox.addSubview(sendButton)
    }
    
    private func addConstraints() {
        contentBox.constrain([
            contentBox.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentBox.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentBox.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -C.padding[6] ) ])
        header.constrainTopCorners(height: 49.0)
        payLabel.constrain([
            payLabel.leadingAnchor.constraint(equalTo: contentBox.leadingAnchor, constant: C.padding[2]),
            payLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: C.padding[2]) ])
        amountLabel.constrain([
            amountLabel.leadingAnchor.constraint(equalTo: payLabel.leadingAnchor),
            amountLabel.topAnchor.constraint(equalTo: payLabel.bottomAnchor)])
        toLabel.constrain([
            toLabel.leadingAnchor.constraint(equalTo: amountLabel.leadingAnchor),
            toLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: C.padding[2]) ])
        address.constrain([
            address.leadingAnchor.constraint(equalTo: toLabel.leadingAnchor),
            address.topAnchor.constraint(equalTo: toLabel.bottomAnchor),
            address.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]) ])
        
        if resolvedAddress != nil {
            resolvedAddressTitle.constrain([
                resolvedAddressTitle.leadingAnchor.constraint(equalTo: toLabel.leadingAnchor),
                resolvedAddressTitle.topAnchor.constraint(equalTo: address.bottomAnchor, constant: C.padding[2]) ])
            resolvedAddressLabel.constrain([
                resolvedAddressLabel.leadingAnchor.constraint(equalTo: resolvedAddressTitle.leadingAnchor),
                resolvedAddressLabel.topAnchor.constraint(equalTo: resolvedAddressTitle.bottomAnchor),
                resolvedAddressLabel.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]) ])
        }
        
        let processingTimeAnchor = resolvedAddress == nil ? address.bottomAnchor : resolvedAddressLabel.bottomAnchor
        processingTime.constrain([
            processingTime.leadingAnchor.constraint(equalTo: address.leadingAnchor),
            processingTime.topAnchor.constraint(equalTo: processingTimeAnchor, constant: C.padding[2]),
            processingTime.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]) ])
        sendLabel.constrain([
            sendLabel.leadingAnchor.constraint(equalTo: processingTime.leadingAnchor),
            sendLabel.topAnchor.constraint(equalTo: processingTime.bottomAnchor, constant: C.padding[2]),
            sendLabel.trailingAnchor.constraint(lessThanOrEqualTo: send.leadingAnchor) ])
        send.constrain([
            send.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]),
            sendLabel.firstBaselineAnchor.constraint(equalTo: send.firstBaselineAnchor) ])
        feeLabel.constrain([
            feeLabel.leadingAnchor.constraint(equalTo: sendLabel.leadingAnchor),
            feeLabel.topAnchor.constraint(equalTo: sendLabel.bottomAnchor) ])
        fee.constrain([
            fee.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]),
            fee.firstBaselineAnchor.constraint(equalTo: feeLabel.firstBaselineAnchor) ])
        totalLabel.constrain([
            totalLabel.leadingAnchor.constraint(equalTo: feeLabel.leadingAnchor),
            totalLabel.topAnchor.constraint(equalTo: feeLabel.bottomAnchor) ])
        total.constrain([
            total.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]),
            total.firstBaselineAnchor.constraint(equalTo: totalLabel.firstBaselineAnchor) ])
        cancel.constrain([
            cancel.leadingAnchor.constraint(equalTo: contentBox.leadingAnchor, constant: C.padding[2]),
            cancel.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: C.padding[2]),
            cancel.trailingAnchor.constraint(equalTo: contentBox.centerXAnchor, constant: -C.padding[1]),
            cancel.bottomAnchor.constraint(equalTo: contentBox.bottomAnchor, constant: -C.padding[2]) ])
        sendButton.constrain([
            sendButton.leadingAnchor.constraint(equalTo: contentBox.centerXAnchor, constant: C.padding[1]),
            sendButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: C.padding[2]),
            sendButton.trailingAnchor.constraint(equalTo: contentBox.trailingAnchor, constant: -C.padding[2]),
            sendButton.bottomAnchor.constraint(equalTo: contentBox.bottomAnchor, constant: -C.padding[2]) ])
    }
    
    private func confirmationFeeLabel() -> String {
        if amount.currency != feeAmount.currency && feeAmount.currency.isEthereum {
            return L10n.Confirmation.feeLabelETH
        } else {
            return L10n.Confirmation.feeLabel
        }
    }
    
    private func setInitialData() {
        view.backgroundColor = .clear
        
        var payLabelTitle = ""
        if isStake {
            if addressText == currency.wallet?.receiveAddress {
                payLabelTitle = L10n.Staking.unstake
            } else {
                payLabelTitle = L10n.Staking.stake
            }
        } else {
            payLabelTitle = L10n.Confirmation.send
        }
        
        payLabel.setup(with: .text(payLabelTitle))
        
        let toLabelTitle = isStake ? L10n.Confirmation.validatorAddress : L10n.Confirmation.to
        toLabel.setup(with: .text(toLabelTitle))
        
        let totalAmount = (amount.currency == feeAmount.currency) ? amount + feeAmount : amount
        let displayTotal = Amount(amount: totalAmount,
                                  rate: amount.rate,
                                  minimumFractionDigits: amount.minimumFractionDigits)
        
        let amountLabelTitle = isStake ? currency.wallet?.balance.tokenDescription ?? "" : amount.combinedDescription
        amountLabel.setup(with: .text(amountLabelTitle))
        
        address.setup(with: .text(addressText))
        
        processingTime.text = currency.feeText(forIndex: displayFeeLevel.rawValue)
        
        sendLabel.text = L10n.Confirmation.amountLabel
        sendLabel.adjustsFontSizeToFitWidth = true
        send.text = amount.description
        feeLabel.text = confirmationFeeLabel()
        fee.text = feeAmount.description
        
        total.setup(with: .text(displayTotal.description))
        
        if currency.isERC20Token {
            totalLabel.isHidden = true
            total.isHidden = true
        }
        
        cancel.tap = strongify(self) { myself in
            myself.dismiss(animated: true, completion: myself.cancelCallback)
        }
        header.closeCallback = strongify(self) { myself in
            myself.dismiss(animated: true, completion: myself.cancelCallback)
        }
        sendButton.tap = strongify(self) { myself in
            myself.dismiss(animated: true, completion: myself.successCallback)
        }
        
        contentBox.layer.cornerRadius = CornerRadius.common.rawValue
        contentBox.layer.masksToBounds = true
        
        if resolvedAddress == nil {
            resolvedAddressTitle.type = nil
            resolvedAddressLabel.text = nil
            resolvedAddressTitle.isHidden = true
            resolvedAddressLabel.isHidden = true
        } else {
            resolvedAddressLabel.text = resolvedAddress?.humanReadableAddress
            resolvedAddressTitle.type = resolvedAddress?.type
        }
        
        if isStake {
            feeLabel.isHidden = true
            fee.isHidden = true
            
            total.isHidden = true
            totalLabel.isHidden = true
            
            sendLabel.isHidden = true
            send.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
