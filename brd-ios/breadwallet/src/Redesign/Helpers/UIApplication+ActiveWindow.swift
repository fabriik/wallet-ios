// 
//  UIApplication+ActiveWindow.swift
//  breadwallet
//
//  Created by Rok on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension UIApplication {
    var activeWindow: UIWindow? {
        return windows.filter { $0.isKeyWindow }.first
    }
}
