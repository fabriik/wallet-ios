// 
//  ThemeManager.swift
//  breadwallet
//
//  Created by Rok on 10/05/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class ThemeManager {
    private var colors: [String: String]
    private var inverseColors: [String: String]
    
    static var shared = ThemeManager()
    
    init() {
        guard let path = Bundle.main.path(forResource: "theme", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let colors = dict["colors"] as? [String: String],
              let inverseColors = dict["inverse-colors"] as? [String: String]
                // TODO: get fonts / other theme configs as well
        else {
            fatalError("Theme.plist error")
        }
        self.colors = colors
        self.inverseColors = inverseColors
    }
    
    func color(for key: String) -> UIColor {
        guard let color = colors[key]
        else {
            return .clear
        }
        return UIColor(hex: color)
    }
    
    func inverseColor(for key: String) -> UIColor {
        guard let color = inverseColors[key]
        else {
            return .clear
        }
        return UIColor(hex: color)
    }
    
    func font(for key: String, size: CGFloat) -> UIFont {
        guard let fontName = UIFont(name: key, size: size)
        else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return fontName
    }
}
