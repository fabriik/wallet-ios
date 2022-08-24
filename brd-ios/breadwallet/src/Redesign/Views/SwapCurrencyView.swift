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
    var formattedFiatString: String?
    var formattedTokenString: String?
    var fee: Amount?
    var title: LabelViewModel?
    var feeDescription: LabelViewModel?
}

class SwapCurrencyView: FEView<SwapCurrencyConfiguration, SwapCurrencyViewModel>, UITextFieldDelegate {
    enum FeeAndAmountsStackViewState {
        case shown, hidden
    }
    
    var didTapSelectAsset: (() -> Void)?
    var didChangeFiatAmount: ((String?) -> Void)?
    var didChangeCryptoAmount: ((String?) -> Void)?
    var didChangeContent: (() -> Void)?
    
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
        view.delegate = self
        view.addTarget(self, action: #selector(fiatAmountDidChange(_:)), for: .editingChanged)
        
        decidePlaceholder(for: view)
        
        return view
    }()
    
    private lazy var cryptoAmountField: UITextField = {
        let view = UITextField()
        view.textColor = LightColors.Icons.one
        view.font = Fonts.Title.four
        view.tintColor = view.textColor
        view.textAlignment = .right
        view.keyboardType = .decimalPad
        view.delegate = self
        view.addTarget(self, action: #selector(cryptoAmountDidChange(_:)), for: .editingChanged)
        
        decidePlaceholder(for: view)
        
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
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    lazy var selectorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = Margins.small.rawValue
        view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                         action: #selector(selectorTapped(_:))))
        return view
    }()
    
    private lazy var currencyIconImageView: FEImageView = {
        let view = FEImageView()
        // TODO: Configs for corner radius on FEImageViews are not working because radius is being set to "content" view instead of image.
        view.layer.cornerRadius = CornerRadius.small.rawValue
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var codeLabel: FELabel = {
        let view = FELabel()
        view.font = Fonts.Title.four
        view.textColor = LightColors.Icons.one
        view.textAlignment = .center
        return view
    }()
    
    private lazy var selectorImageView: FEImageView = {
        let view = FEImageView()
        view.setup(with: .imageName("chevrondown"))
        view.setupCustomMargins(all: .extraSmall)
        view.tintColor = LightColors.primary
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
        view.alpha = 0
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
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(cryptoStack)
        cryptoStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        cryptoStack.addArrangedSubview(selectorStackView)
        selectorStackView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.extraHuge.rawValue)
        }
        
        selectorStackView.addArrangedSubview(currencyIconImageView)
        currencyIconImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.medium.rawValue)
        }
        
        selectorStackView.addArrangedSubview(codeLabel)
        selectorStackView.addArrangedSubview(selectorImageView)
        selectorImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.small.rawValue)
        }
        
        let spacer = UIView()
        cryptoStack.addArrangedSubview(spacer)
        cryptoStack.addArrangedSubview(cryptoAmountField)
        cryptoAmountField.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().priority(.low)
        }
        
        cryptoAmountField.addSubview(cryptoLineView)
        cryptoLineView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.minimum.rawValue)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(feeAndAmountsStackView)
        feeAndAmountsStackView.snp.makeConstraints { make in
            make.height.equalTo(Margins.extraHuge.rawValue)
        }
        
        feeAndAmountsStackView.addArrangedSubview(feeLabel)
        feeAndAmountsStackView.addArrangedSubview(feeAmountLabel)
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
        decidePlaceholder(for: textField)
        
        let cleanedText = textField.text?.cleanupFormatting()
        didChangeFiatAmount?(cleanedText)
    }
    
    @objc func cryptoAmountDidChange(_ textField: UITextField) {
        decidePlaceholder(for: textField)
        
        let cleanedText = textField.text?.cleanupFormatting()
        didChangeCryptoAmount?(cleanedText)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        decidePlaceholder(for: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let cleanedText = textField.text
        
        if textField == fiatAmountField {
            didChangeFiatAmount?(cleanedText)
        } else if textField == cryptoAmountField {
            didChangeCryptoAmount?(cleanedText)
        }
        
        decidePlaceholder(for: textField)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: SwapCurrencyConfiguration?) {
        super.configure(with: config)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: SwapCurrencyViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel.title)
        
        if !fiatAmountField.isFirstResponder {
            fiatAmountField.text = viewModel.formattedFiatString
        }
        
        if !cryptoAmountField.isFirstResponder {
            cryptoAmountField.text = viewModel.formattedTokenString
        }
        
        codeLabel.text = viewModel.amount?.currency.code
        codeLabel.sizeToFit()
        
        currencyIconImageView.setup(with: .image(viewModel.amount?.currency.imageSquareBackground))
        
        if let fee = viewModel.fee {
            feeAmountLabel.text = "\(fee.tokenDescription) \n\(fee.fiatDescription)"
        }
        
        feeLabel.setup(with: viewModel.feeDescription)
        
        let isHidden = feeAndAmountsStackView.alpha == 0
        let noFee = viewModel.fee == nil || viewModel.fee?.tokenValue == 0 || viewModel.amount?.tokenValue == 0
        
        feeAndAmountsStackView.isHidden = noFee
        guard isHidden != noFee else { return }
        
        feeAndAmountsStackView.isHidden = false
        feeAndAmountsStackView.alpha = isHidden ? 0 : 1
        UIView.animate(withDuration: Presets.Animation.duration, animations: { [weak self] in
            self?.feeAndAmountsStackView.alpha = isHidden ? 1: 0
        }, completion: { [weak self] _ in
            self?.feeAndAmountsStackView.isHidden = !isHidden
            self?.didChangeContent?()
        })
    }
    
    @objc private func selectorTapped(_ sender: Any) {
        didTapSelectAsset?()
    }
    
    private func setPlaceholder(for field: UITextField, with string: String = "0.00") {
        if let textColor = field.textColor,
           let font = field.font {
            field.attributedPlaceholder = NSAttributedString(string: string,
                                                             attributes: [NSAttributedString.Key.foregroundColor: textColor,
                                                                          NSAttributedString.Key.font: font]
            )
        }
    }
    
    private func decidePlaceholder(for field: UITextField) {
        if field.text?.isEmpty == true && field.isFirstResponder {
            setPlaceholder(for: field, with: "")
        } else {
            setPlaceholder(for: field)
        }
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
            var frame = topFrame.convert(topFrame.bounds, from: bottomFrame)
            frame.size.height = topFrame.bounds.height
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
