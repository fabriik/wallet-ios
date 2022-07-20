// 
//  TitleValueView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Presets {
    struct TitleValue {
        static var horizontal = TitleValueConfiguration(title: .init(font: Fonts.Body.one, textColor: LightColors.Text.two),
                                                      value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one, textAlignment: .right))
        
        static var vertical = TitleValueConfiguration(title: .init(font: Fonts.Body.two, textColor: LightColors.Text.one),
                                                      value: .init(font: Fonts.Body.two, textColor: LightColors.Text.one))
    }
}

struct TitleValueConfiguration: Configurable {
    var title: LabelConfiguration
    var value: LabelConfiguration
}

struct TitleValueViewModel: ViewModel {
    var title: LabelViewModel
    var value: LabelViewModel
}

class TitleValueView: FEView<TitleValueConfiguration, TitleValueViewModel> {
    
    var axis: NSLayoutConstraint.Axis = .horizontal {
        didSet {
            mainStack.axis = axis
            layoutIfNeeded()
        }
    }
    
    private lazy var mainStack: UIStackView = {
        let view = UIStackView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var valueLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(valueLabel)
    }
    
    override func configure(with config: TitleValueConfiguration?) {
        guard let config = config else { return }

        super.configure(with: config)
        titleLabel.configure(with: config.title)
        valueLabel.configure(with: config.value)
    }
    
    override func setup(with viewModel: TitleValueViewModel?) {
        super.setup(with: viewModel)
        titleLabel.setup(with: viewModel?.title)
        valueLabel.setup(with: viewModel?.value)
    }
}
