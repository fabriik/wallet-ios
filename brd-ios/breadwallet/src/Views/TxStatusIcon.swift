// 
//  TxStatusIcon.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2020-09-10.
//  Copyright © 2020 Breadwinner AG. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import SwiftUI

enum StatusIcon {
    case sent
    case received
    case swap
    
    var icon: UIImage? {
        switch self {
        case .sent: return .init(named: "send")
        case .received: return .init(named: "receive")
        case .swap: return .init(named: "exchange")
        }
    }
}
