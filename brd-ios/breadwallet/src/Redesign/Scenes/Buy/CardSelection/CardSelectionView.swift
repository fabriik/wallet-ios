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
    var title: LabelConfiguration? = .init(font: Fonts.caption, textColor: LightColors.Text.one)
    var logo: BackgroundConfiguration? = .init(tintColor: LightColors.Icons.two)
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
    
    private lazy var titleLabel: FELabel = {
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
        
        mainStack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
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
        selectorStack.addArrangedSubview(arrowImageView)
    }
    
    override func configure(with config: CardSelectionConfiguration?) {
        super.configure(with: config)
        titleLabel.configure(with: config?.title)
        arrowImageView.configure(with: config?.arrow)
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: CardSelectionViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
        titleLabel.isHidden = viewModel?.title == nil
        
        cardDetailsView.setup(with: .init(logo: viewModel?.logo,
                                          cardNumber: viewModel?.cardNumber,
                                          expiration: viewModel?.expiration))
        
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
