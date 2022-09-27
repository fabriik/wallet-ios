// 
//  FEInfoView.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum DismissType {
    /// After 5 sec
    case auto
    /// Tap to remove
    case tapToDismiss
    /// Non interactable
    case persistent
}

struct InfoViewConfiguration: Configurable {
    var headerLeadingImage: BackgroundConfiguration?
    var headerTitle: LabelConfiguration?
    var headerTrailing: ButtonConfiguration?
    var status: StatusViewConfiguration?
    
    var title: LabelConfiguration?
    var description: LabelConfiguration?
    var button: ButtonConfiguration?
    
    var background: BackgroundConfiguration?
    var shadow: ShadowConfiguration?
}

struct InfoViewModel: ViewModel {
    var kyc: KYC?
    var headerLeadingImage: ImageViewModel?
    var headerTitle: LabelViewModel?
    var headerTrailing: ButtonViewModel?
    var status: VerificationStatus?
    
    var title: LabelViewModel?
    var description: LabelViewModel?
    var button: ButtonViewModel?
    
    var dismissType: DismissType = .auto
}

class FEInfoView: FEView<InfoViewConfiguration, InfoViewModel> {
    
    // MARK: public properties
    var headerButtonCallback: (() -> Void)?
    var trailingButtonCallback: (() -> Void)?
    
    // MARK: Lazy UI
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Margins.small.rawValue
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
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
    
    private lazy var statusView: WrapperView<FELabel> = {
        let view = WrapperView<FELabel>()
        return view
    }()
    
    private lazy var headerTrailingView: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(headerButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var descriptionLabel: FELabel = {
        let label = FELabel()
        return label
    }()
    
    private lazy var trailingButton: FEButton = {
        let view = FEButton()
        view.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        
        verticalStackView.addArrangedSubview(headerStackView)
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
        
        headerStackView.addArrangedSubview(statusView)
        statusView.content.setupCustomMargins(vertical: .zero, horizontal: .small)
        statusView.snp.makeConstraints { make in
            make.width.equalTo(Margins.extraLarge.rawValue * 4)
        }
        
        headerStackView.addArrangedSubview(headerTrailingView)
        headerTrailingView.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        
        verticalStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(Margins.large.rawValue)
        }

        verticalStackView.addArrangedSubview(descriptionLabel)

        verticalStackView.addArrangedSubview(trailingButton)
        trailingButton.snp.makeConstraints { make in
            make.height.equalTo(Margins.extraHuge.rawValue)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func configure(with config: InfoViewConfiguration?) {
        toggleVisibility(isShown: config != nil)
        
        guard let config = config else { return }
        super.configure(with: config)
        
        backgroundColor = config.background?.backgroundColor
        headerLeadingView.configure(with: config.headerLeadingImage)
        headerTitleLabel.configure(with: config.headerTitle)
        headerTrailingView.configure(with: config.headerTrailing)
        statusView.wrappedView.configure(with: config.status?.title)
        statusView.configure(background: config.status?.background)
        
        titleLabel.configure(with: config.title)
        descriptionLabel.configure(with: config.description)
        trailingButton.configure(with: config.button)
        
        configure(background: config.background)
        configure(shadow: config.shadow)
    }
    
    override func configure(background: BackgroundConfiguration?) {
        super.configure(background: background)
        guard let border = background?.border else { return }
        let content = self
        
        let radius = border.cornerRadius == .fullRadius ? content.bounds.width / 2 : border.cornerRadius.rawValue
        content.layer.cornerRadius = radius
        content.layer.borderWidth = border.borderWidth
        content.layer.borderColor = border.tintColor.cgColor
        
        content.layer.masksToBounds = false
        content.layer.shadowColor = UIColor.clear.cgColor
        content.layer.shadowOpacity = 0
        content.layer.shadowOffset = .zero
        content.layer.shadowRadius = 0
        content.layer.shadowPath = UIBezierPath(roundedRect: content.bounds, cornerRadius: radius).cgPath
        content.layer.shouldRasterize = true
        content.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func setup(with viewModel: InfoViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        headerLeadingView.setup(with: viewModel.headerLeadingImage)
        headerLeadingView.isHidden = viewModel.headerLeadingImage == nil
        
        headerTitleLabel.setup(with: viewModel.headerTitle)
        headerTitleLabel.isHidden = viewModel.headerTitle == nil
        
        headerTrailingView.setup(with: viewModel.headerTrailing)
        headerTrailingView.isHidden = viewModel.headerTrailing == nil
        
        statusView.wrappedView.setup(with: .text(viewModel.status?.title))
        statusView.isHidden = viewModel.status == VerificationStatus.none
        
        titleLabel.setup(with: viewModel.title)
        titleLabel.isHidden = viewModel.title == nil
        
        descriptionLabel.setup(with: viewModel.description)
        descriptionLabel.isHidden = viewModel.description == nil
        
        trailingButton.setup(with: viewModel.button)
        trailingButton.isHidden = viewModel.button == nil
        
        switch viewModel.dismissType {
        case .auto:
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.viewTapped(nil)
            }
            
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
            
        case .tapToDismiss:
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
            
        default:
            break
        }
        
        guard headerLeadingView.isHidden,
              headerTitleLabel.isHidden,
              headerTrailingView.isHidden else {
            layoutIfNeeded()
            
            return
        }
        
        headerStackView.isHidden = true
        
        layoutIfNeeded()
    }
    
    @objc private func headerButtonTapped(_ sender: UIButton?) {
        headerButtonCallback?()
    }
    
    @objc private func trailingButtonTapped(_ sender: UIButton?) {
        trailingButtonCallback?()
    }
    
    @objc private func viewTapped(_ sender: Any?) {
        Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.alpha = 0
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
    
    private func toggleVisibility(isShown: Bool) {
        Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
            self?.alpha = isShown ? 1.0 : 0.0
        }
    }
}
