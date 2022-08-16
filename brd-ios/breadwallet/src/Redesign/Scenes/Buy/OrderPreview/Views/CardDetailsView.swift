// 
//  CardDetailsView.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 16/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct CardDetailsConfiguration: Configurable {
    var logo: BackgroundConfiguration? = .init(tintColor: LightColors.Icons.two)
    var cardNumber: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Icons.one)
    var expiration: LabelConfiguration?
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.primary,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.cardDetails)
}

struct CardDetailsViewModel: ViewModel {
    var logo: ImageViewModel?
    var cardNumber: LabelViewModel? = .text("Select a payment method")
    var expiration: LabelViewModel?
}

class CardDetailsView: FEView<CardDetailsConfiguration, CardDetailsViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var selectorStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var cardNumberLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var logoImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var expirationLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(selectorStack)
        selectorStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.medium.rawValue)
        }
        
        selectorStack.addArrangedSubview(logoImageView)
        selectorStack.addArrangedSubview(cardNumberLabel)
        let spacer = UIView()
        selectorStack.addArrangedSubview(spacer)
        spacer.snp.makeConstraints { make in
            make.width.equalToSuperview().priority(.low)
        }
        selectorStack.addArrangedSubview(expirationLabel)
    }
    
    override func configure(with config: CardDetailsConfiguration?) {
        super.configure(with: config)
        logoImageView.configure(with: config?.logo)
        cardNumberLabel.configure(with: config?.cardNumber)
        expirationLabel.configure(with: config?.expiration)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: CardDetailsViewModel?) {
        super.setup(with: viewModel)
        
        logoImageView.setup(with: viewModel?.logo)
        logoImageView.isHidden = viewModel?.logo == nil
        
        cardNumberLabel.setup(with: viewModel?.cardNumber)
        expirationLabel.setup(with: viewModel?.expiration)
    }
}
