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

enum GiftStatus {
    case claimed
    case reclaimed
    case unclaimed
    case unsent
}

enum StatusIcon {
    case sent, sendPending, sendFailed
    case received, receivePending, receiveFailed
    case swapComplete, swapPending, swapFailed
    case gift(GiftStatus)
    
    var icon: String {
        switch self {
        case .sent: return "send_success"
        case .sendPending: return "send_pending"
        case .sendFailed: return "send_failed"
            
        case .received: return "purchase_success"
        case .receivePending: return "purchase_pending"
        case .receiveFailed: return "purchase_failed"
            
        case .swapComplete: return "swap_success"
        case .swapPending: return "swap_pending"
        case .swapFailed: return "swap_failed"
            
        case .gift(let status):
            switch status {
            case .claimed:
                return "ClaimedGift"
            case .reclaimed:
                return "ReclaimedGift"
            case .unclaimed:
                return "UnclaimedGift"
            case .unsent:
                return "UnsentGift"
            }
        }
    }
}
