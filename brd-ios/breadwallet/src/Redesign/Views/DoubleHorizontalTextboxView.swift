//
//  DoubleHorizontalTextboxView.swift
//  breadwallet
//
//  Created by Rok on 30/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct DoubleHorizontalTextboxViewConfiguration: Configurable {
}

struct DoubleHorizontalTextboxViewModel: ViewModel {
    var title: LabelViewModel?
    var first: TextFieldModel?
    var second: TextFieldModel?
}

class DoubleHorizontalTextboxView: FEView<DoubleHorizontalTextboxViewConfiguration, DoubleHorizontalTextboxViewModel> {
    var contentSizeChanged: (() -> Void)?
    var valueChanged: ((_ first: String?, _ second: String?) -> Void)?
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        return view
    }()
    
    private lazy var contentStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.small.rawValue
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var firstTextField: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private lazy var secondTextfield: FETextField = {
        let view = FETextField()
        return view
    }()
    
    private var first: String?
    private var second: String?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        // TODO: Constant
        let titleHeight: CGFloat = 20
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
        
        stack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleHeight)
        }
        
        stack.addArrangedSubview(contentStack)
        contentStack.addArrangedSubview(firstTextField)
        contentStack.addArrangedSubview(secondTextfield)
    }
    
    override func configure(with config: DoubleHorizontalTextboxViewConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: .init(font: Fonts.Body.two, textColor: LightColors.Text.two))
        firstTextField.configure(with: Presets.TextField.primary)
        secondTextfield.configure(with: Presets.TextField.primary)
    }
    
    override func setup(with viewModel: DoubleHorizontalTextboxViewModel?) {
        super.setup(with: viewModel)
        
        titleLabel.setup(with: viewModel?.title)
        titleLabel.isHidden = viewModel?.title == nil
        
        first = viewModel?.first?.value
        second = viewModel?.second?.value
        firstTextField.setup(with: viewModel?.first)
        secondTextfield.setup(with: viewModel?.second)
        
        firstTextField.valueChanged = { [weak self] in
            self?.first = $0
            self?.stateChanged()
        }
        
        secondTextfield.valueChanged = { [weak self] in
            self?.second = $0
            self?.stateChanged()
        }
        
        stack.layoutIfNeeded()
    }
    
    private func stateChanged() {
        valueChanged?(first, second)
        
        Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.content.layoutIfNeeded()
            self?.contentSizeChanged?()
        }
    }
}
