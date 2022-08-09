// 
//  CardSelectionView.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct CardSelectionConfiguration: Configurable {
    var title: LabelConfiguration? = .init(font: Fonts.overline, textColor: LightColors.Icons.one)
    var logo: BackgroundConfiguration?
    var cardNumber: LabelConfiguration? = .init(font: Fonts.Subtitle.two, textColor: LightColors.Icons.one)
    var expiration: LabelConfiguration?
    var arrow: BackgroundConfiguration?
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct CardSelectionViewModel: ViewModel {
    var title: LabelViewModel? = .text("Pay with")
    var logo: ImageViewModel?
    var cardNumber: LabelViewModel? = .text("Select a payment method")
    var expiration: LabelViewModel?
    var arrow: ImageViewModel? = .imageName("arrowRight")
    var userInteractionEnabled = false
}

class CardSelectionView: FEView<CardSelectionConfiguration, CardSelectionViewModel> {
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    private lazy var titleLalbel: FELabel = {
        let view = FELabel()
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
    
    private lazy var arrowImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    var didTapSelectAsset: (() -> Void)?
    
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
        
        mainStack.addArrangedSubview(titleLalbel)
        titleLalbel.snp.makeConstraints { make in
            make.height.equalTo(Margins.large.rawValue)
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
        selectorStack.addArrangedSubview(arrowImageView)
    }
    
    override func configure(with config: CardSelectionConfiguration?) {
        super.configure(with: config)
        titleLalbel.configure(with: config?.title)
        logoImageView.configure(with: config?.logo)
        cardNumberLabel.configure(with: config?.cardNumber)
        expirationLabel.configure(with: config?.expiration)
        arrowImageView.configure(with: config?.arrow)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: CardSelectionViewModel?) {
        super.setup(with: viewModel)
        
        titleLalbel.setup(with: viewModel?.title)
        titleLalbel.isHidden = viewModel?.title == nil
        
        logoImageView.setup(with: viewModel?.logo)
        logoImageView.isHidden = viewModel?.logo == nil
        
        cardNumberLabel.setup(with: viewModel?.cardNumber)
        cardNumberLabel.isHidden = viewModel?.cardNumber == nil
        
        expirationLabel.setup(with: viewModel?.expiration)
        expirationLabel.isHidden = viewModel?.expiration == nil
        
        arrowImageView.setup(with: viewModel?.arrow)
        arrowImageView.isHidden = viewModel?.arrow == nil
        
        guard viewModel?.userInteractionEnabled == true else {
            selectorStack.gestureRecognizers?.forEach { selectorStack.removeGestureRecognizer($0) }
            return
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(assetSelectorTapped(_:)))
        selectorStack.addGestureRecognizer(tap)
    }
    
    @objc private func assetSelectorTapped(_ sender: Any) {
        didTapSelectAsset?()
    }
}
