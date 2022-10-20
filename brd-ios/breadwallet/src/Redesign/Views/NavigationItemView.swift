// 
//  ImageLabelView.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import SnapKit

struct NavigationConfiguration: Configurable {
    var image: BackgroundConfiguration?
    var label: LabelConfiguration?
    var button: ButtonConfiguration?
    
    var shadow: ShadowConfiguration?
    var background: BackgroundConfiguration?
}

struct NavigationViewModel: ViewModel {
    var image: ImageViewModel?
    var label: LabelViewModel?
    var button: ButtonViewModel?
}

class NavigationItemView: FEView<NavigationConfiguration, NavigationViewModel> {
    private lazy var verticalStack: UIStackView = {
        let view = UIStackView()
        view.spacing = Margins.medium.rawValue
        return view
    }()
    
    private lazy var leadingImageView: FEImageView = {
        let view = FEImageView()
        return view
    }()
    
    private lazy var titleLabel: FELabel = {
        let view = FELabel()
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = LightColors.Background.two
        return view
    }()
    
    private lazy var trailing: FEButton = {
        let view = FEButton()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configure(background: config?.background)
        configure(shadow: config?.shadow)
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.height.equalTo(ViewSizes.extraSmall.rawValue)
            make.top.leading.trailing.equalToSuperview()
        }
        
        verticalStack.addArrangedSubview(leadingImageView)
        leadingImageView.snp.makeConstraints { make in
            make.width.equalTo(ViewSizes.medium.rawValue)
        }
        
        leadingImageView.setupClearMargins()
        verticalStack.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().priority(.low)
        }
        
        verticalStack.addArrangedSubview(trailing)
        trailing.snp.makeConstraints { make in
            make.width.equalTo(Margins.huge.rawValue)
        }
        
        addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(verticalStack.snp.bottom).offset(Margins.large.rawValue)
            make.bottom.equalToSuperview()
            
            make.leading.equalToSuperview().inset(-Margins.extraExtraHuge.rawValue)
            make.trailing.equalToSuperview().offset(Margins.extraExtraHuge.rawValue)
            make.height.equalTo(ViewSizes.minimum.rawValue)
        }
    }
    
    override func configure(with config: NavigationConfiguration?) {
        guard let config = config else { return }
        super.configure(with: config)
        
        leadingImageView.configure(with: config.image)
        titleLabel.configure(with: config.label)
        trailing.configure(with: config.button)
        
        configure(background: config.background)
        configure(shadow: config.shadow)
    }
    
    override func setup(with viewModel: NavigationViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        leadingImageView.setup(with: viewModel.image)
        leadingImageView.isHidden = viewModel.image == nil
        titleLabel.setup(with: viewModel.label)
        titleLabel.isHidden = viewModel.label == nil
        trailing.setup(with: viewModel.button)
        trailing.isHidden = viewModel.button == nil
    }
}
