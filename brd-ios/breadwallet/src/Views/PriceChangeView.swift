//
//  PriceChangeView.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2019-04-01.
//  Copyright © 2019 breadwallet LLC. All rights reserved.
//

import UIKit

enum PriceChangeViewStyle {
    case percentOnly
    case percentAndAbsolute
}

class PriceChangeView: UIView, Subscriber {
    
    var currency: Currency? {
        didSet {
            //These cells get recycled, so we need to cancel any previous subscriptions
            Store.unsubscribe(self)
            subscribeToPriceChange()
        }
    }
    
    private let percentLabel = UILabel(font: Theme.body3)
    private let absoluteLabel = UILabel(font: Theme.body3)
    private let prefixLabel = UILabel(font: Theme.body3)
    
    private var priceInfo: FiatPriceInfo? {
        didSet {
            handlePriceChange()
        }
    }
    
    private var prefixValue: String? {
        guard let change24Hrs = priceInfo?.change24Hrs else { return nil }
        
        if change24Hrs > 0 {
            return "+"
        } else if change24Hrs < 0 {
            return "-"
        }
        
        return nil
    }
    
    private var valueColor: UIColor? {
        guard let change24Hrs = priceInfo?.change24Hrs else { return nil }
        
        if change24Hrs > 0 {
            return .greenCheck
        } else if change24Hrs < 0 {
            return .redCheck
        }
        
        return .shuttleGrey
    }
    
    private var currencyNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = Rate.symbolMap[Store.state.defaultCurrencyCode]
        return formatter
    }
    
    private let style: PriceChangeViewStyle
    
    init(style: PriceChangeViewStyle) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        prefixLabel.constrain([
            prefixLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.half),
            prefixLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
        percentLabel.constrain([
            percentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            percentLabel.leadingAnchor.constraint(equalTo: prefixLabel.trailingAnchor, constant: 3.0)])
        absoluteLabel.constrain([
            absoluteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            absoluteLabel.leadingAnchor.constraint(equalTo: percentLabel.trailingAnchor, constant: C.padding[1]/2.0),
            absoluteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -C.padding[1])])
        if style == .percentOnly {
            percentLabel.constrain([
                percentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4.0)])
        }
    }
    
    private func addSubviews() {
        addSubview(percentLabel)
        addSubview(prefixLabel)
        addSubview(absoluteLabel)
    }
    
    private func handlePriceChange() {
        guard let priceChange = priceInfo else { return }
        
        let percentText = String(format: "%.2f%%", fabs(priceChange.changePercentage24Hrs))
        var textColor = valueColor
        
        if style == .percentAndAbsolute, let absoluteString = currencyNumberFormatter.string(from: NSNumber(value: abs(priceChange.change24Hrs))) {
            absoluteLabel.text = "(\(absoluteString))"
            percentLabel.text = percentText
            textColor = Theme.primaryBackground
            layoutIfNeeded()
        } else if style == .percentOnly {
            UIView.transition(with: percentLabel,
                              duration: 0.1,
                              options: .curveEaseIn,
                              animations: { [weak self] in
                self?.percentLabel.text = percentText
            })
        }
        
        prefixLabel.text = prefixValue
        prefixLabel.textColor = textColor
        percentLabel.textColor = textColor
        absoluteLabel.textColor = textColor
    }
    
    private func subscribeToPriceChange() {
        guard let currency = currency else { return }
        Store.subscribe(self, selector: { $0[currency]?.fiatPriceInfo != $1[currency]?.fiatPriceInfo }, callback: {
            self.priceInfo = $0[currency]?.fiatPriceInfo
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
