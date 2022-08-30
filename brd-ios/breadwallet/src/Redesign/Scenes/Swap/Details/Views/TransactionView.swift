// 
//  TransactionView.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 21.7.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct TransactionConfiguration: Configurable {
    var title = LabelConfiguration(font: Fonts.Body.two, textColor: LightColors.Text.two, textAlignment: .center, numberOfLines: 1)
    var description = LabelConfiguration(font: Fonts.Subtitle.two, textColor: LightColors.Text.one, textAlignment: .center, numberOfLines: 1)
    var shadow: ShadowConfiguration? = Presets.Shadow.light
    var background: BackgroundConfiguration? = .init(backgroundColor: LightColors.Background.one,
                                                     tintColor: LightColors.Text.one,
                                                     border: Presets.Border.zero)
}

struct TransactionViewModel: ViewModel {
    var title: String
    var description: String
}

class TransactionView: FEView<TransactionConfiguration, TransactionViewModel> {
    
    var copyCallback: ((String?) -> Void)?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var descriptionLabel: FELabel = {
        let view = FELabel()
        return view
    }()

    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualTo(content.snp.topMargin).inset(Margins.medium.rawValue)
            make.bottom.greaterThanOrEqualTo(content.snp.bottomMargin).inset(Margins.medium.rawValue)
            make.leading.greaterThanOrEqualTo(content.snp.leadingMargin)
        }
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: TransactionConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: config?.title)
        descriptionLabel.configure(with: config?.description)
        configure(shadow: config?.shadow)
        configure(background: config?.background)
    }
    
    override func setup(with viewModel: TransactionViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        titleLabel.setup(with: .text(viewModel.title))
        descriptionLabel.setup(with: .text(viewModel.description))
    }
}
