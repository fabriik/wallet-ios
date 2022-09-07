// 
//  OrderView.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct OrderConfiguration: Configurable {
    var title: LabelConfiguration?
    var value: LabelConfiguration?
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
    var contentBackground: BackgroundConfiguration?
}

struct OrderViewModel: ViewModel {
    var title: String
    var value: NSAttributedString
    var showsFullValue: Bool
}

class OrderView: FEView<OrderConfiguration, OrderViewModel> {
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.extraSmall.rawValue
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var bottomStack: WrapperView<UIStackView> = {
        let view = WrapperView<UIStackView>()
        view.wrappedView.alignment = .center
        view.wrappedView.distribution = .fill
        return view
    }()
    
    private lazy var valueLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    var didCopyValue: ((String?) -> Void)?
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualTo(content.snp.topMargin).inset(Margins.medium.rawValue)
            make.bottom.greaterThanOrEqualTo(content.snp.bottom).inset(Margins.medium.rawValue)
            make.leading.greaterThanOrEqualTo(content.snp.leadingMargin).inset(Margins.huge.rawValue)
        }
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(bottomStack)
        
        bottomStack.wrappedView.addArrangedSubview(valueLabel)
        bottomStack.content.setupCustomMargins(vertical: .extraSmall, horizontal: .medium)
        bottomStack.setContentHuggingPriority(.required, for: .horizontal)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        content.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bottomStack.configure(background: config?.contentBackground)
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: OrderConfiguration?) {
        super.configure(with: config)
        
        titleLabel.configure(with: config?.title)
        valueLabel.configure(with: config?.value)
        bottomStack.configure(background: config?.contentBackground)
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setup(with viewModel: OrderViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        titleLabel.setup(with: .text(viewModel.title))
        valueLabel.setup(with: .attributedText(viewModel.value))
    }
    
    // MARK: - User interaction
    
    @objc private func viewTapped() {
        didCopyValue?(viewModel?.value.string)
    }
}