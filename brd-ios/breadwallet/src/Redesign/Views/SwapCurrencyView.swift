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
    var amount: Amount?
    var fee: Amount?
    var title: String?
}

class SwapCurrencyView: FEView<SwapCurrencyConfiguration, SwapCurrencyViewModel> {
    enum FeeAndAmountsStackViewState {
        case shown, hidden
    }
    
    var didChangeFiatAmount: ((String?) -> Void)?
    var didChangeCryptoAmount: ((String?) -> Void)?
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var headerStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.caption
        view.textColor = LightColors.Icons.one
        view.textAlignment = .left
        return view
    }()
    
    private lazy var fiatStack: UIStackView = {
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
        view.keyboardType = .decimalPad
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
    
    private lazy var fiatLineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var fiatCurrencyLabel: FELabel = {
        let view = FELabel()
        view.text = Store.state.defaultCurrencyCode
        view.font = Fonts.Subtitle.two
        view.textColor = LightColors.Icons.one
        view.textAlignment = .right
        return view
    }()
    
    private lazy var cryptoStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    lazy var selectorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var iconImageView: FEImageView = {
        let view = FEImageView()
        // TODO: we got configs 4 that
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.setup(with: .imageName("next"))
        return view
    }()
    
    private lazy var codeLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Title.four
        view.textColor = LightColors.Icons.one
        view.textAlignment = .left
        return view
    }()
    
    private lazy var selectorImageView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .imageName("chevrondown"))
        view.setupCustomMargins(all: .extraSmall)
        view.tintColor = LightColors.primary
        return view
    }()
    
    private lazy var cryptoAmountField: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Icons.one
        view.font = Fonts.Title.four
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .decimalPad
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
    
    private lazy var cryptoLineView: UIView = {
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
        view.numberOfLines = 2
        return view
    }()
    
    lazy var feeAmountLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.caption
        view.textColor = LightColors.Text.two
        view.textAlignment = .right
        view.numberOfLines = 2
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        content.setupCustomMargins(all: .large)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        mainStack.addArrangedSubview(headerStack)
        headerStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.small.rawValue)
        }
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(fiatStack)
        
        fiatStack.addArrangedSubview(fiatAmountField)
        fiatStack.addArrangedSubview(fiatCurrencyLabel)
        
        fiatAmountField.addSubview(fiatLineView)
        fiatLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(cryptoStack)
        cryptoStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        cryptoStack.addArrangedSubview(selectorStackView)
        selectorStackView.snp.makeConstraints { make in
            make.width.equalTo(136)
        }
        
        selectorStackView.addArrangedSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.width.equalTo(selectorStackView.snp.height)
        }
        
        selectorStackView.addArrangedSubview(codeLabel)
        selectorStackView.addArrangedSubview(selectorImageView)
        selectorImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.medium.rawValue)
        }
        
        cryptoStack.addArrangedSubview(cryptoAmountField)
        cryptoAmountField.snp.makeConstraints { make in
            make.width.equalToSuperview().priority(.low)
        }
        
        cryptoAmountField.addSubview(cryptoLineView)
        cryptoLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(feeAndAmountsStackView)
        feeAndAmountsStackView.addArrangedSubview(feeLabel)
        feeAndAmountsStackView.addArrangedSubview(feeAmountLabel)
        feeAndAmountsStackView.isHidden = true
    }
    
    func toggleFeeAndAmountsStackView(state: FeeAndAmountsStackViewState, animated: Bool = true) {
        UIView.animate(withDuration: animated ? Presets.Animation.duration : 0,
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.feeAndAmountsStackView.alpha = state == .hidden ? 0.0 : 1.0
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
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8
        
        if !fiatAmountField.isFirstResponder,
           let value = viewModel.amount?.fiatValue {
            fiatAmountField.text = formatter.string(for: value)
        }
        
        if !cryptoAmountField.isFirstResponder,
           let value = viewModel.amount?.tokenValue {
            cryptoAmountField.text = formatter.string(for: value)
        }
        
        codeLabel.text = viewModel.amount?.currency.code
        
        if let selectedCurrencyIcon = viewModel.amount?.currency.imageSquareBackground {
                iconImageView.setup(with: .image(selectedCurrencyIcon))
        } else {
            iconImageView.setup(with: .imageName("close"))
        }
        
        if let fee = viewModel.fee {
            feeAmountLabel.text = "\(fee.tokenDescription) \n\(fee.fiatDescription)"
            feeAmountLabel.sizeToFit()
            feeAndAmountsStackView.snp.makeConstraints { make in
                make.height.equalTo(feeAmountLabel.frame.height)
            }
        }
        
        feeAndAmountsStackView.isHidden = viewModel.fee == nil || viewModel.fee?.tokenValue == 0
        titleLabel.text = viewModel.title
        layoutIfNeeded()
    }
}

extension SwapCurrencyView {
    static func animateSwitchPlaces(sender: UIButton?, baseSwapCurrencyView: SwapCurrencyView, termSwapCurrencyView: SwapCurrencyView) {
        UIView.animate(withDuration: Presets.Animation.duration * 3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3,
                       options: .curveEaseInOut) {
            sender?.isEnabled = false
            sender?.transform = sender?.transform == .identity ? CGAffineTransform(rotationAngle: .pi) : .identity
            
            let topFrame = baseSwapCurrencyView.selectorStackView
            let bottomFrame = termSwapCurrencyView.selectorStackView
            let frame = topFrame.convert(topFrame.bounds, from: bottomFrame)
            let verticalDistance = frame.minY - topFrame.bounds.maxY + topFrame.frame.height
            
            baseSwapCurrencyView.selectorStackView.transform = baseSwapCurrencyView.selectorStackView.transform == .identity
            ? .init(translationX: 0, y: verticalDistance) : .identity
            termSwapCurrencyView.selectorStackView.transform = termSwapCurrencyView.selectorStackView.transform == .identity
            ? .init(translationX: 0, y: -verticalDistance) : .identity
        }
        
        UIView.animate(withDuration: Presets.Animation.duration, delay: Presets.Animation.duration, options: []) {
            SwapCurrencyView.updateAlpha(baseSwapCurrencyView: baseSwapCurrencyView, termSwapCurrencyView: termSwapCurrencyView, value: 0.2)
        } completion: { _ in
            UIView.animate(withDuration: Presets.Animation.duration) {
                SwapCurrencyView.updateAlpha(baseSwapCurrencyView: baseSwapCurrencyView, termSwapCurrencyView: termSwapCurrencyView, value: 1.0)
                
                sender?.isEnabled = true
            }
        }
    }
    
    private static  func updateAlpha(baseSwapCurrencyView: SwapCurrencyView, termSwapCurrencyView: SwapCurrencyView, value: CGFloat) {
        baseSwapCurrencyView.titleLabel.alpha = value
        baseSwapCurrencyView.fiatStack.alpha = value
        baseSwapCurrencyView.fiatAmountField.alpha = value
        baseSwapCurrencyView.fiatCurrencyLabel.alpha = value
        baseSwapCurrencyView.cryptoAmountField.alpha = value
        baseSwapCurrencyView.feeAmountLabel.alpha = value
        baseSwapCurrencyView.feeAmountLabel.alpha = value
        
        termSwapCurrencyView.titleLabel.alpha = value
        termSwapCurrencyView.fiatStack.alpha = value
        termSwapCurrencyView.fiatAmountField.alpha = value
        termSwapCurrencyView.fiatCurrencyLabel.alpha = value
        termSwapCurrencyView.cryptoAmountField.alpha = value
        termSwapCurrencyView.feeAmountLabel.alpha = value
        termSwapCurrencyView.feeAmountLabel.alpha = value
    }
}
