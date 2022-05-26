// 
//  ImageView.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

enum ImageViewModel: ViewModel {
    case animation(String)
    case imageName(String)
    case image(UIImage)
    case url(String)
}

class FEImageView: FEView<BackgroundConfiguration, ImageViewModel> {
    
    // MARK: Lazy UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - View setup
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        // Border
        configure(with: config)
    }
    override func setupSubviews() {
        super.setupSubviews()
        
        content.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(content.snp.margins)
        }
        content.setupClearMargins()
    }
    
    // MARK: NCViewProtocol
    override func configure(with config: BackgroundConfiguration?) {
        super.configure(with: config)
        guard let border = config?.border else { return }
        
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
    
    // MARK: ViewModelable
    public override func setup(with viewModel: ImageViewModel?) {
        guard let viewModel = viewModel else { return }
        super.setup(with: viewModel)
        
        switch viewModel {
        case .image(let image):
            imageView.image = image
            
        case .imageName(let name):
            imageView.image = .init(named: name)
            
        default:
            return
        }
        
        setupSubviews()
        configure(with: config)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
