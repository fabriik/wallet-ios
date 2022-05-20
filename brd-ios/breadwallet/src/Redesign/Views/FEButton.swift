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
    var backgroundConfiguration: BackgroundConfiguration?
    var selectedConfiguration: BackgroundConfiguration?
    var disabledConfiguration: BackgroundConfiguration?
    var shadowConfiguration: ShadowConfiguration?
    
    mutating func with(border: BorderConfiguration) -> Self {
        backgroundConfiguration?.border = border
        selectedConfiguration?.border = border
        disabledConfiguration?.border = border
        return self
    }
}

struct ButtonViewModel: ViewModel {
    var title: String?
    var image: UIImage?
}

class FEButton: UIButton, ViewProtocol, StateDisplayable, Borderable, Shadable {
    
    var displayState: DisplayState = .normal
    var config: ButtonConfiguration?
    var viewModel: ButtonViewModel?
    
    override var isSelected: Bool {
        didSet {
            animateTo(state: isSelected ? .selected : .normal)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            animateTo(state: isHighlighted ? .highlighted : .normal)
        }   
    }
    
    override var isEnabled: Bool {
        didSet {
            animateTo(state: isEnabled ? .normal : .disabled)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Border
        configure(background: config?.backgroundConfiguration)
        // Shadow
        configure(shadow: config?.shadowConfiguration)
    }
    
    func configure(with config: ButtonConfiguration?) {
        guard let config = config else { return }

        self.config = config
        backgroundColor = config.backgroundConfiguration?.backgroundColor
        setTitleColor(config.backgroundConfiguration?.tintColor, for: .normal)
        setTitleColor(config.disabledConfiguration?.tintColor, for: .disabled)
        setTitleColor(config.selectedConfiguration?.tintColor, for: .selected)
        setTitleColor(config.selectedConfiguration?.tintColor, for: .highlighted)
        configure(background: config.backgroundConfiguration)
        configure(shadow: config.shadowConfiguration)
    }
    
    func setup(with viewModel: ButtonViewModel?) {
        guard let viewModel = viewModel else { return }

        self.viewModel = viewModel
        setTitle(viewModel.title, for: .normal)
        setImage(viewModel.image, for: .normal)
    }
    
    func animateTo(state: DisplayState, withAnimation: Bool = true) {
        let background: BackgroundConfiguration?
        
        switch state {
        case .normal:
            background = config?.backgroundConfiguration
            
            // TODO: any need to split?
        case .highlighted, .selected:
            background = config?.selectedConfiguration
            
        case .disabled:
            background = config?.disabledConfiguration
            
        case .error:
            // TODO: handle?
            return
        }
        
        // TODO: constant for duration
        UIView.animate(withDuration: withAnimation ? 0.25 : 0) { [weak self] in
            self?.backgroundColor = background?.backgroundColor
            self?.tintColor = background?.tintColor
        }
    }
    
    func configure(shadow: ShadowConfiguration?) {
        guard let shadow = shadow else { return }
        
        layer.masksToBounds = false
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = shadow.opacity.rawValue
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(roundedRect: marginableView.bounds, cornerRadius: shadow.cornerRadius.rawValue).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(background: BackgroundConfiguration? = nil) {
        marginableView.backgroundColor = background?.backgroundColor
        tintColor = background?.tintColor
        
        guard let border = background?.border else { return }
        layer.cornerRadius = border.cornerRadius.rawValue
        layer.borderWidth = border.borderWidth
        layer.borderColor = border.tintColor.cgColor
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: border.cornerRadius.rawValue).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
