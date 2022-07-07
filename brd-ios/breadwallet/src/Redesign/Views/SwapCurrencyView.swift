// 
//  SwapCurrencyView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapCurrencyConfiguration: Configurable {
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
}

struct SwapCurrencyViewModel: ViewModel {
    var fiatAmountString: String?
    var cryptoAmountString: String?
}

class SwapCurrencyView: FEView<SwapCurrencyConfiguration, SwapCurrencyViewModel> {
    enum FeeAndAmountsStackViewState {
        case shown, hidden
    }
    
    var didChangeFiatAmount: ((String?) -> Void)?
    var didChangeCryptoAmount: ((String?) -> Void)?
    
    private lazy var currencyContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var currencyHeaderStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var iHaveLabel: FELabel = {
        let view = FELabel()
        view.text = "I have 100 BSV"
        view.font = Fonts.caption
        view.textColor = LightColors.Icons.one
        view.textAlignment = .left
        return view
    }()
    
    private lazy var fiatTitleStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var fiatAmountField: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Icons.one
        view.font = Fonts.Subtitle.two
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(fiatAmountDidChange(_:)), for: .editingChanged)
        
        if let textColor = view.textColor, let font = view.font {
            view.attributedPlaceholder = NSAttributedString(
                string: "0.00",
                attributes: [NSAttributedString.Key.foregroundColor: textColor,
                             NSAttributedString.Key.font: font]
            )
        }
        
        return view
    }()
    
    private lazy var fiatAmountFieldlineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var fiatCurrencySignLabel: FELabel = {
        let view = FELabel()
        view.text = Store.state.defaultCurrencyCode
        view.font = Fonts.Subtitle.two
        view.textColor = LightColors.Icons.one
        view.textAlignment = .right
        return view
    }()
    
    lazy var currencySelectorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var currencyIconImageView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .imageName("camera-btn-pressed"))
        return view
    }()
    
    private lazy var currencyIconTitleLabel: FELabel = {
        let view = FELabel()
        view.text = Currencies.shared.currencies.randomElement()?.code.uppercased() ?? ""
        view.font = Fonts.Title.four
        view.textColor = LightColors.Icons.one
        view.textAlignment = .left
        return view
    }()
    
    private lazy var currencySelectionArrowIconView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .imageName("chevrondown"))
        view.setupCustomMargins(all: .extraSmall)
        view.tintColor = LightColors.primary
        return view
    }()
    
    private lazy var cryptoAmountLabel: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Icons.one
        view.font = Fonts.Title.four
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .numberPad
        view.addTarget(self, action: #selector(cryptoAmountDidChange(_:)), for: .editingChanged)
        
        if let textColor = view.textColor, let font = view.font {
            view.attributedPlaceholder = NSAttributedString(
                string: "0.00",
                attributes: [NSAttributedString.Key.foregroundColor: textColor,
                             NSAttributedString.Key.font: font]
            )
        }
        
        return view
    }()
    
    private lazy var currencyAmountTitleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var feeAndAmountsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var feeLabel: FELabel = {
        let view = FELabel()
        view.text = "Sending network fee\n(included)"
        view.font = Fonts.caption
        view.textColor = LightColors.Text.two
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    lazy var fromToConversionLabel: FELabel = {
        let view = FELabel()
        view.text = "0.00023546\nBSV 0.01 USD"
        view.font = Fonts.caption
        view.textColor = LightColors.Text.two
        view.textAlignment = .right
        view.numberOfLines = 0
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        addSubview(currencyContainerView)
        currencyContainerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        currencyContainerView.addSubview(currencyHeaderStackView)
        currencyHeaderStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Margins.large.rawValue).priority(.required)
            make.height.equalTo(ViewSizes.small.rawValue)
            make.leading.trailing.equalToSuperview().inset(Margins.large.rawValue)
        }
        
        fiatTitleStackView.addArrangedSubview(fiatAmountField)
        fiatTitleStackView.addArrangedSubview(fiatCurrencySignLabel)
        
        fiatAmountField.addSubview(fiatAmountFieldlineView)
        fiatAmountFieldlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        currencyHeaderStackView.addArrangedSubview(iHaveLabel)
        currencyHeaderStackView.addArrangedSubview(fiatTitleStackView)
        
        currencyContainerView.addSubview(currencySelectorStackView)
        currencySelectorStackView.snp.makeConstraints { make in
            make.top.equalTo(currencyHeaderStackView.snp.bottom).offset(Margins.medium.rawValue)
            make.leading.equalTo(currencyHeaderStackView)
            make.height.equalTo(32)
        }
        
        currencySelectorStackView.addArrangedSubview(currencyIconImageView)
        currencyIconImageView.snp.makeConstraints { make in
            make.width.equalTo(currencySelectorStackView.snp.height)
        }
        
        currencySelectorStackView.addArrangedSubview(currencyIconTitleLabel)
        currencySelectorStackView.addArrangedSubview(currencySelectionArrowIconView)
        
        currencyContainerView.addSubview(cryptoAmountLabel)
        cryptoAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(currencySelectorStackView.snp.top)
            make.trailing.equalTo(currencyHeaderStackView)
            make.leading.lessThanOrEqualTo(currencySelectorStackView).offset(Margins.small.rawValue).priority(.low)
            make.height.equalTo(currencySelectorStackView.snp.height)
        }
        
        cryptoAmountLabel.addSubview(currencyAmountTitleLineView)
        currencyAmountTitleLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        currencyContainerView.addSubview(feeAndAmountsStackView)
        feeAndAmountsStackView.snp.makeConstraints { make in
            make.top.equalTo(currencySelectorStackView.snp.bottom).offset(Margins.huge.rawValue).priority(.required)
            make.leading.trailing.equalTo(currencyHeaderStackView)
            make.bottom.equalToSuperview().inset(Margins.huge.rawValue)
        }
        
        feeAndAmountsStackView.addArrangedSubview(feeLabel)
        feeAndAmountsStackView.addArrangedSubview(fromToConversionLabel)
    }
    
    func toggleFeeAndAmountsStackView(state: FeeAndAmountsStackViewState, animated: Bool = true) {
        UIView.animate(withDuration: animated ? Presets.Animation.duration : 0,
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.feeAndAmountsStackView.alpha = state == .hidden ? 0.0 : 1.0
            
            self?.feeAndAmountsStackView.snp.updateConstraints { make in
                let bottomInset = state == .hidden ? -Margins.huge.rawValue : Margins.huge.rawValue
                make.bottom.equalToSuperview().inset(bottomInset)
            }
            
            guard animated else { return }
            self?.feeAndAmountsStackView.layoutIfNeeded()
        }
    }
    
    @objc func fiatAmountDidChange(_ textField: UITextField) {
        didChangeFiatAmount?(textField.text)
    }
    
    @objc func cryptoAmountDidChange(_ textField: UITextField) {
        didChangeCryptoAmount?(textField.text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: SwapCurrencyConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        configure(shadow: config.shadow)
    }
    
    override func setup(with viewModel: SwapCurrencyViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        fiatAmountField.text = viewModel.fiatAmountString
        cryptoAmountLabel.text = viewModel.cryptoAmountString
    }
}

extension SwapCurrencyView {
    static func animateSwitchPlaces(sender: UIButton?, topSwapCurrencyView: SwapCurrencyView, bottomSwapCurrencyView: SwapCurrencyView) {
        UIView.animate(withDuration: Presets.Animation.duration * 3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3,
                       options: .curveEaseInOut) {
            sender?.isEnabled = false
            sender?.transform = sender?.transform == .identity ? CGAffineTransform(rotationAngle: .pi) : .identity
            
            let topFrame = topSwapCurrencyView.currencySelectorStackView
            let bottomFrame = bottomSwapCurrencyView.currencySelectorStackView
            let frame = topFrame.convert(topFrame.bounds, from: bottomFrame)
            let verticalDistance = frame.minY - topFrame.bounds.maxY + topFrame.frame.height
            
            topSwapCurrencyView.currencySelectorStackView.transform = topSwapCurrencyView.currencySelectorStackView.transform == .identity
            ? .init(translationX: 0, y: verticalDistance) : .identity
            bottomSwapCurrencyView.currencySelectorStackView.transform = bottomSwapCurrencyView.currencySelectorStackView.transform == .identity
            ? .init(translationX: 0, y: -verticalDistance) : .identity
        }
        
        UIView.animate(withDuration: Presets.Animation.duration, delay: Presets.Animation.duration, options: []) {
            SwapCurrencyView.updateAlpha(topSwapCurrencyView: topSwapCurrencyView, bottomSwapCurrencyView: bottomSwapCurrencyView, value: 0.2)
        } completion: { _ in
            UIView.animate(withDuration: Presets.Animation.duration) {
                SwapCurrencyView.updateAlpha(topSwapCurrencyView: topSwapCurrencyView, bottomSwapCurrencyView: bottomSwapCurrencyView, value: 1.0)
                
                sender?.isEnabled = true
            }
        }
    }
    
    private static  func updateAlpha(topSwapCurrencyView: SwapCurrencyView, bottomSwapCurrencyView: SwapCurrencyView, value: CGFloat) {
        topSwapCurrencyView.iHaveLabel.alpha = value
        topSwapCurrencyView.fiatTitleStackView.alpha = value
        topSwapCurrencyView.fiatAmountField.alpha = value
        topSwapCurrencyView.fiatCurrencySignLabel.alpha = value
        topSwapCurrencyView.cryptoAmountLabel.alpha = value
        topSwapCurrencyView.feeLabel.alpha = value
        topSwapCurrencyView.fromToConversionLabel.alpha = value
        
        bottomSwapCurrencyView.iHaveLabel.alpha = value
        bottomSwapCurrencyView.fiatTitleStackView.alpha = value
        bottomSwapCurrencyView.fiatAmountField.alpha = value
        bottomSwapCurrencyView.fiatCurrencySignLabel.alpha = value
        bottomSwapCurrencyView.cryptoAmountLabel.alpha = value
        bottomSwapCurrencyView.feeLabel.alpha = value
        bottomSwapCurrencyView.fromToConversionLabel.alpha = value
    }
}
