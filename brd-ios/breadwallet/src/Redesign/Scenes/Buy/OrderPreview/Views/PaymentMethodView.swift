// 
//  PaymentMethodView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 16/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct PaymentMethodConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.caption, textColor: LightColors.Text.one)
    var logo: BackgroundConfiguration? = .init(tintColor: LightColors.Icons.two)
    var cardNumber: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Icons.one)
    var expiration: LabelConfiguration?
    var cvvTitle: TitleValueConfiguration? = Presets.TitleValue.verticalSmall
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct PaymentMethodViewModel: ViewModel {
    var methodTitle: LabelViewModel? = .text("Payment method")
    var logo: ImageViewModel?
    var cardNumber: LabelViewModel?
    var expiration: LabelViewModel?
    var cvvTitle: TitleValueViewModel? = .init(title: .text("Please confirm your CVV"), value: .text(""))
    var cvv: TextFieldModel? = .init(placeholder: "CVV")
}

class PaymentMethodView: FEView<PaymentMethodConfiguration, PaymentMethodViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var methodTitleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var selectorStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var cardDetailsView: CardDetailsView = {
        let view = CardDetailsView()
        return view
    }()
    
    private lazy var cvvTitleLabel: TitleValueView = {
        let view = TitleValueView()
        return view
    }()
    
    private lazy var cvvTextField: FETextField = {
        let view = FETextField()
        view.hideFilledTitleStack = true
        return view
    }()
    
    var didTypeCVV: ((String?) -> Void)? {
        get {
            cvvTextField.valueChanged
        }
        
        set {
            cvvTextField.valueChanged = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupCustomMargins(all: .large)
        
        mainStack.addArrangedSubview(methodTitleLabel)
        methodTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(Margins.large.rawValue)
        }
        mainStack.addArrangedSubview(selectorStack)
        selectorStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        selectorStack.addArrangedSubview(cardDetailsView)
        cardDetailsView.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        mainStack.addArrangedSubview(cvvTitleLabel)
        mainStack.addArrangedSubview(cvvTextField)
        cvvTextField.snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
        }
    }
    
    override func configure(with config: PaymentMethodConfiguration?) {
        super.configure(with: config)
        methodTitleLabel.configure(with: config?.title)
        cvvTitleLabel.configure(with: config?.cvvTitle)
        cardDetailsView.configure(with: .init())
        cvvTitleLabel.configure(with: config?.cvvTitle)
        cvvTextField.configure(with: Presets.TextField.number.setSecure(true))
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: PaymentMethodViewModel?) {
        super.setup(with: viewModel)
        
        methodTitleLabel.setup(with: viewModel?.methodTitle)
        methodTitleLabel.isHidden = viewModel?.methodTitle == nil
        
        cvvTitleLabel.setup(with: viewModel?.cvvTitle)
        cvvTitleLabel.isHidden = viewModel?.cvvTitle == nil
        
        cvvTextField.setup(with: viewModel?.cvv)
        cvvTextField.isHidden = viewModel?.cvv == nil
        
        cardDetailsView.setup(with: .init(logo: viewModel?.logo,
                                          cardNumber: viewModel?.cardNumber,
                                          expiration: viewModel?.expiration))
    }
    
    // MARK: - User interaction
}
