// 
//  WrapperPopupView.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct WrapperPopupConfiguration: Configurable {
    var background: BackgroundConfiguration = .init(backgroundColor: .white, tintColor: .black, border: Presets.Border.zero)
    var leading: BackgroundConfiguration?
    var title = LabelConfiguration(font: Fonts.Title.six, textColor: LightColors.Text.one, textAlignment: .center)
    var trailing = Presets.Button.blackIcon
    var buttons: [ButtonConfiguration] = [
        Presets.Button.primary,
        Presets.Button.secondary
    ]
}

struct WrapperPopupViewModel: ViewModel {
    var leading: ImageViewModel?
    var title: LabelViewModel?
    var trailing: ButtonViewModel?
    var buttons: [ButtonViewModel] = []
}

class WrapperPopupView<T: ViewProtocol & UIView>: UIView,
                                         Wrappable,
                                         Reusable,
                                         Borderable {
    
    // MARK: Lazy UI
    lazy var content: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.large.rawValue
        return view
    }()
    
    var callbacks: [(()-> Void)] = []
    var config: WrapperPopupConfiguration?
    var viewModel: WrapperPopupViewModel?
    
    lazy var wrappedView = T()
    
    private lazy var blurView: UIView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = Margins.small.rawValue
        
        return stack
    }()
    
    private lazy var headerLeadingView: FEImageView = {
        let view = FEImageView()
        view.setupCustomMargins(all: .extraSmall)
        return view
    }()
    
    private lazy var headerTitleLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var headerTrailingView: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Outline.two
        return view
    }()
    
    private lazy var buttonStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = Margins.small.rawValue
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
    }

    func setupSubviews() {
        addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(content)
        content.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(snp.leadingMargin)
            make.top.greaterThanOrEqualToSuperview()
        }
        content.layoutMargins = UIEdgeInsets(top: Margins.large.rawValue,
                                             left: Margins.huge.rawValue,
                                             bottom: Margins.large.rawValue,
                                             right: Margins.huge.rawValue)
        content.isLayoutMarginsRelativeArrangement = true
        
        setupCustomMargins(vertical: .extraHuge)

        content.addArrangedSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.height.equalTo(Margins.huge.rawValue)
        }
        
        headerStackView.addArrangedSubview(headerLeadingView)
        headerLeadingView.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        
        headerStackView.addArrangedSubview(headerTitleLabel)
        headerTitleLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().priority(.low)
        }
        
        headerStackView.addArrangedSubview(headerTrailingView)
        headerTrailingView.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        content.addArrangedSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        content.addArrangedSubview(wrappedView)
        content.addArrangedSubview(buttonStack)
        
        isUserInteractionEnabled = true
        content.isUserInteractionEnabled = true
        wrappedView.isUserInteractionEnabled = true
    }
    
    func setup(_ closure: (T) -> Void) {
        closure(wrappedView)
    }
    
    func configure(with config: WrapperPopupConfiguration?) {
        guard let config = config else { return }
        self.config = config
        
        configure(background: config.background)
        headerLeadingView.configure(with: config.leading)
        headerTitleLabel.configure(with: config.title)
        headerTrailingView.configure(with: config.trailing)
    }
    
    func setup(with viewModel: WrapperPopupViewModel?) {
        guard let viewModel = viewModel else { return }
        self.viewModel = viewModel

        headerLeadingView.setup(with: viewModel.leading)
        headerTitleLabel.setup(with: viewModel.title)
        headerTrailingView.setup(with: viewModel.trailing)
        
        prepareButtons()
        
        guard headerLeadingView.isHidden,
              headerTitleLabel.isHidden,
              headerTrailingView.isHidden else {
            return
        }
        lineView.isHidden = true
        headerStackView.isHidden = true
    }
    
    private func prepareButtons() {
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let buttons = viewModel?.buttons else { return }
        
        for model in buttons {
            let index = buttonStack.arrangedSubviews.count
            let config = config?.buttons[index]
            let button = FEButton()
            button.configure(with: config)
            button.setup(with: model)
            buttonStack.addArrangedSubview(button)
            button.snp.makeConstraints { make in
                make.height.equalTo(FieldHeights.common.rawValue)
            }
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        guard subview == wrappedView else { return }
        
        removeFromSuperview()
    }
    
    func prepareForReuse() {
        (wrappedView as? Reusable)?.prepareForReuse()
    }

    func configure(background: BackgroundConfiguration?) {
        guard let border = background?.border else { return }
        content.backgroundColor = background?.backgroundColor
        tintColor = background?.tintColor
        
        let radius = border.cornerRadius == .fullRadius ? content.bounds.width / 2 : border.cornerRadius.rawValue
        content.layer.cornerRadius = radius
        content.layer.borderWidth = border.borderWidth
        content.layer.borderColor = border.tintColor.cgColor
        
        content.layer.masksToBounds = false
        content.layer.shadowColor = UIColor.clear.cgColor
        content.layer.shadowOpacity = 0
        content.layer.shadowOffset = .zero
        content.layer.shadowRadius = 0
        content.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        content.layer.shouldRasterize = true
        content.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc func headerButtonTapped(sender: Any) {
        removeFromSuperview()
    }
    
    @objc func buttonTapped(_ sender: Any?) {
        guard let sender = sender as? FEButton,
              let index = buttonStack.arrangedSubviews.firstIndex(where: { $0 == sender }),
        callbacks.count >= index - 1 else {
            removeFromSuperview()
            return
        }
        
        callbacks[index]()
    }
}
