// 
//  FEButton.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct ButtonConfiguration: Configurable {
    var titleConfiguration: LabelConfiguration?
    var backgroundConfiguration: BackgroundConfiguration?
    var selectedConfiguration: BackgroundConfiguration?
    var disabledConfiguration: BackgroundConfiguration?
    var shadowConfiguration: ShadowConfiguration?
    
    func with(border: BorderConfiguration) -> Self {
        var copy = self
        copy.backgroundConfiguration?.border = border
        copy.selectedConfiguration?.border = border
        copy.disabledConfiguration?.border = border
        return copy
    }
    
    func withBorder(normal: BorderConfiguration? = nil,
                    selected: BorderConfiguration? = nil,
                    disabled: BorderConfiguration? = nil) -> ButtonConfiguration {
        var copy = self
        copy.backgroundConfiguration?.border = normal
        copy.selectedConfiguration?.border = selected
        copy.disabledConfiguration?.border = disabled
        return copy
    }
}

struct ButtonViewModel: ViewModel {
    var title: String?
    var isUnderlined = false
    var image: String?
    var enabled = true
}

class FEButton: UIButton, ViewProtocol, StateDisplayable, Borderable, Shadable {
    
    var displayState: DisplayState = .normal
    var config: ButtonConfiguration?
    var viewModel: ButtonViewModel?
    
    override var isSelected: Bool {
        didSet {
            guard isEnabled else { return }
            animateTo(state: isSelected ? .selected : .normal)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard isEnabled else { return }
            animateTo(state: isHighlighted ? .highlighted : .normal)
        }   
    }
    
    override var isEnabled: Bool {
        didSet {
            animateTo(state: isEnabled ? .normal : .disabled, withAnimation: false)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        animateTo(state: displayState, withAnimation: false)
    }
    
    func configure(with config: ButtonConfiguration?) {
        guard let config = config else { return }
        
        contentEdgeInsets = .init(top: Margins.medium.rawValue,
                                  left: Margins.huge.rawValue,
                                  bottom: Margins.medium.rawValue,
                                  right: Margins.huge.rawValue)

        self.config = config
        setTitleColor(config.backgroundConfiguration?.tintColor, for: .normal)
        setTitleColor(config.disabledConfiguration?.tintColor, for: .disabled)
        setTitleColor(config.selectedConfiguration?.tintColor, for: .selected)
        setTitleColor(config.selectedConfiguration?.tintColor, for: .highlighted)
        layoutIfNeeded()
    }
    
    func setup(with viewModel: ButtonViewModel?) {
        guard let viewModel = viewModel else { return }

        self.viewModel = viewModel
        if let title = viewModel.title {
            if viewModel.isUnderlined {
                let attributeString = NSMutableAttributedString(
                    string: title,
                    attributes: [
                        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
                    ]
                )
                setAttributedTitle(attributeString, for: .normal)
            } else {
                setTitle(title, for: .normal)
            }
        }
        
        if let image = viewModel.image {
            setBackgroundImage(.init(named: image), for: .normal)
        }
        
        isEnabled = viewModel.enabled
    }
    
    func animateTo(state: DisplayState, withAnimation: Bool = true) {
        let background: BackgroundConfiguration?
        
        switch state {
        case .normal:
            background = config?.backgroundConfiguration

        case .highlighted, .selected:
            background = config?.selectedConfiguration

        case .disabled:
            background = config?.disabledConfiguration

        case .error, .filled:
            // TODO: handle?
            return
        }
        displayState = state
        let shadow = config?.shadowConfiguration
        
        tintColor = background?.tintColor
        titleLabel?.textColor = background?.tintColor
        titleLabel?.font = Fonts.button
        
        if withAnimation {
            Self.animate(withDuration: Presets.Animation.duration) { [weak self] in
                self?.updateLayout(background: background, shadow: shadow)
            }
        } else {
            UIView.performWithoutAnimation { [weak self] in
                self?.updateLayout(background: background, shadow: shadow)
            }
        }
    }
    
    private func updateLayout(background: BackgroundConfiguration?, shadow: ShadowConfiguration?) {
        configure(background: background)
        configure(shadow: shadow)
    }
    
    func configure(shadow: ShadowConfiguration?) {
        guard let shadow = shadow else { return }
        
        layer.masksToBounds = false
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = shadow.opacity.rawValue
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(roundedRect: marginableView.bounds, cornerRadius: shadow.shadowRadius.rawValue).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(background: BackgroundConfiguration? = nil) {
        backgroundColor = background?.backgroundColor
        
        guard let border = background?.border else { return }
        let radius = border.cornerRadius == .fullRadius ? bounds.height / 2 : border.cornerRadius.rawValue
        layer.cornerRadius = radius
        layer.borderWidth = border.borderWidth
        layer.borderColor = border.tintColor.cgColor
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
