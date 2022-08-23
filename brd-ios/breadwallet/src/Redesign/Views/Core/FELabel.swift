// 
//  FELabel.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct LabelConfiguration: TextConfigurable {
    var font: UIFont = Fonts.caption
    var textColor: UIColor? = LightColors.primary
    var textAlignment: NSTextAlignment = .left
    var numberOfLines: Int = 0
    var lineBreakMode: NSLineBreakMode = .byWordWrapping
}

enum LabelViewModel: ViewModel {
    case text(String?)
    case attributedText(NSAttributedString?)
    case attributedLink(NSAttributedString?, URL?)
}

class FELabel: UILabel, ViewProtocol {
    var viewModel: LabelViewModel?
    var config: LabelConfiguration?
    
    var didTapUrl: ((URL) -> Void)?
    private var url: URL?
    
    func configure(with config: LabelConfiguration?) {
        guard let config = config else { return }
        
        self.config = config
        textAlignment = config.textAlignment
        textColor = config.textColor
        numberOfLines = config.numberOfLines
        lineBreakMode = config.lineBreakMode
        font = config.font
        textColor = config.textColor
    }
    
    func setup(with viewModel: LabelViewModel?) {
        guard let viewModel = viewModel else { return }

        self.viewModel = viewModel
        switch viewModel {
        case .text(let value):
            text = value
            
        case .attributedText(let value):
            attributedText = value
            
        case .attributedLink(let value, let url):
            attributedText = value
            
            guard let url = url else {
                gestureRecognizers?.forEach { removeGestureRecognizer($0) }
                return
            }
            
            self.url = url
            isUserInteractionEnabled = true
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(urlTapped(_:))))
        }
        
        sizeToFit()
        needsUpdateConstraints()
    }
    
    @objc private func urlTapped(_ sender: Any) {
        guard let url = url else { return }
        didTapUrl?(url)
    }
}
