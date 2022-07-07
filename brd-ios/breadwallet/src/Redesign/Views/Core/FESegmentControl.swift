// 
//  FESegmentControl.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SegmentControlConfiguration: Configurable {
    var font: UIFont = Fonts.button
    var normal: BackgroundConfiguration = .init(backgroundColor: LightColors.tertiary, tintColor: LightColors.Text.one)
    var selected: BackgroundConfiguration = .init(backgroundColor: LightColors.primary, tintColor: LightColors.Contrast.two)
}

struct SegmentControlViewModel: ViewModel {
    /// Passing 'nil' leaves the control deselected
    var selectedIndex: Int?
}

class FESegmentControl: UISegmentedControl, ViewProtocol {
    
    var config: SegmentControlConfiguration?
    var viewModel: SegmentControlViewModel?
    
    convenience init() {
        let items = [
            // TODO: localize
            "Min",
            "Max"
        ]
        
        self.init(items: items)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
        clipsToBounds = true
        
        if subviews.indices.contains(selectedSegmentIndex),
            let foregroundImageView = subviews[numberOfSegments] as? UIImageView {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 6, dy: 6)
            foregroundImageView.image = UIImage.imageForColor(LightColors.primary)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.frame.height / 2
        }
    }
    
    func configure(with config: SegmentControlConfiguration?) {
        guard let config = config else { return }
        
        snp.makeConstraints { make in
            make.height.equalTo(FieldHeights.common.rawValue)
        }
        
        backgroundColor = config.normal.backgroundColor
        selectedSegmentTintColor = config.selected.backgroundColor
        
        setTitleTextAttributes([
            .font: config.font,
            .foregroundColor: config.normal.tintColor
        ], for: .normal)
        
        setTitleTextAttributes([
            .font: config.font,
            .foregroundColor: config.selected.tintColor
        ], for: .selected)
        
        // TODO: Divider should be the same color as the background color. There is something wrong with the background color.
        setDividerImage(UIImage.imageForColor(UIColor(red: 223.0/255.0,
                                                      green: 228.0/255.0,
                                                      blue: 239.0/255.0,
                                                      alpha: 1.0)),
                        forLeftSegmentState: .normal,
                        rightSegmentState: .normal,
                        barMetrics: .default)
        
    }
    
    func setup(with viewModel: SegmentControlViewModel?) {
        guard let index = viewModel?.selectedIndex else {
            selectedSegmentIndex = UISegmentedControl.noSegment
            return
        }
        
        selectedSegmentIndex = index
    }
}
