//
//  AccountFooterView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-11-16.
//  Copyright © 2016-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class AccountFooterView: UIView, Subscriber {
    
    static let height: CGFloat = 67.0

    var sendCallback: (() -> Void)?
    var receiveCallback: (() -> Void)?
    
    private var hasSetup = false
    private let currency: Currency
    private let toolbar = UIToolbar()
    
    init(currency: Currency) {
        self.currency = currency
        super.init(frame: .zero)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !hasSetup else { return }
        setup()
        hasSetup = true
    }

    private func toRadian(value: Int) -> CGFloat {
        return CGFloat(Double(value) / 180.0 * .pi)
    }
    
    private func setup() {
        let separator = UIView(color: LightColors.Outline.one)
        addSubview(toolbar)
        addSubview(separator)
        
        backgroundColor = LightColors.Background.one
        
        toolbar.clipsToBounds = true // to remove separator line
        toolbar.isOpaque = true
        toolbar.isTranslucent = false
        toolbar.barTintColor = backgroundColor
        
        // constraints
        toolbar.constrainTopCorners(height: AccountFooterView.height)
        separator.constrainTopCorners(height: 0.5)
        
        setupToolbarButtons()
    }
    
    private func setupToolbarButtons() {
        let buttons = [
            (L10n.Button.send, #selector(AccountFooterView.send)),
            (L10n.Button.receive, #selector(AccountFooterView.receive))
        ].compactMap { (title, selector) -> UIBarButtonItem in
            let button = UIButton.rounded(title: title.uppercased())
            button.addTarget(self, action: selector, for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        }
        buttons.first?.isEnabled = currency.wallet?.balance.isZero != true
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        flexibleSpace.width = Margins.large.rawValue
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = Margins.small.rawValue
        let paddingWidth = Margins.large.rawValue * 2 + Margins.small.rawValue
        
        toolbar.items = [
            flexibleSpace,
            buttons[0],
            fixedSpace,
            buttons[1],
            flexibleSpace
        ]
        
        let buttonWidth = (bounds.width - paddingWidth) / CGFloat(buttons.count)
        let buttonHeight = CGFloat(44.0)
        
        buttons.forEach {
            $0.customView?.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        }
    }

    @objc private func send() { sendCallback?() }
    @objc private func receive() { receiveCallback?() }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
