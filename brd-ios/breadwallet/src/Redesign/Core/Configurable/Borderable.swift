// 
//  Borderable.swift
//  breadwallet
//
//  Created by Rok on 11/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

protocol Borderable {
    func configure(border: BorderConfiguration?)
}

extension Borderable where Self: Marginable {
    
    func configure(border: BorderConfiguration?) {
        guard let border = border else { return }
        
        marginableView.layer.masksToBounds = true
        marginableView.layer.cornerRadius = border.cornerRadius.rawValue
        marginableView.layer.borderWidth = border.borderWidth
        marginableView.layer.borderColor = border.tintColor.cgColor
    }
}
