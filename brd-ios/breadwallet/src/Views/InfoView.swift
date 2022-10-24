//
//  InfoView.swift
//  breadwallet
//
//  Created by InfoView.swift on 2019-03-25.
//  Copyright © 2019 Breadwinner AG. All rights reserved.
//

import UIKit

class InfoView: UIView {
    
    private let imageSize: CGFloat = 32
    
    private let infoLabel = UILabel()
    private let infoImageView = UIImageView()
    
    var text: String = "" {
        didSet {
            infoLabel.text = text
        }
    }
    
    var imageName: String = "warning" {
        didSet {
            infoImageView.image = UIImage(named: imageName)?.tinted(with: LightColors.Error.one)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoImageView.layer.cornerRadius = infoImageView.frame.height * CornerRadius.fullRadius.rawValue
    }
    
    private func setUp() {
        backgroundColor = LightColors.Background.three
        layer.cornerRadius = CornerRadius.common.rawValue
        
        infoLabel.numberOfLines = 0
        infoLabel.textColor = LightColors.Text.one
        infoLabel.font = Fonts.Body.two
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.minimumScaleFactor = 0.5
        
        infoImageView.contentMode = .center
        infoImageView.tintColor = LightColors.Error.one
        infoImageView.backgroundColor = LightColors.Background.one

        addSubview(infoLabel)
        addSubview(infoImageView)
        
        self.heightAnchor.constraint(equalToConstant: ViewSizes.extralarge.rawValue).isActive = true
        
        infoImageView.constrain([
            infoImageView.heightAnchor.constraint(equalToConstant: imageSize),
            infoImageView.widthAnchor.constraint(equalToConstant: imageSize),
            infoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            infoImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: C.padding[2])
            ])
        
        let textPadding: CGFloat = 20
        
        infoLabel.constrain([
            infoLabel.leftAnchor.constraint(equalTo: infoImageView.rightAnchor, constant: C.padding[2]),
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: textPadding),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textPadding),
            infoLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -(textPadding * 2))
            ])
    }
    
}
