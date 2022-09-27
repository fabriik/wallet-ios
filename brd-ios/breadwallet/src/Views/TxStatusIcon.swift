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
    case sent
    case received
    case pending(CGFloat) //progress associated value
    case failed
    case refunded
    case swapComplete, swapPending, swapFailed
    case buyPending
    case gift(GiftStatus)
    
    var icon: String {
        switch self {
        case .sent: return "sendArrow"
        case .received: return "receivedArrow"
        case .pending: return "pendingIndicator"
        case .failed: return "failed"
        case .refunded: return "refunded"
        case .swapComplete: return "swapCompleteIndicator"
        case .swapPending: return "swapPendingIndicator"
        case .buyPending: return "pendingReceivingArrow"
        case .swapFailed: return "failed"
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
    
    var color: Color {
        switch self {
        case .sent:
            return Color(UIColor.fromHex("EFEFF2"))
        case .received, .swapComplete:
            return Color(Theme.success).opacity(0.16)
        case .pending, .swapPending, .buyPending:
            return Color(Theme.accent).opacity(0.16)
        case .failed, .swapFailed, .refunded:
            return Color(Theme.error).opacity(0.16)
        case .gift(let status):
            switch status {
            case .claimed:
                return Color.white
            case .reclaimed:
                return Color.white
            case .unclaimed:
                return Color.white
            case .unsent:
                return Color.white
            }
        }
    }
}

struct TxStatusIcon: View {
    let status: StatusIcon
    
    var body: some View {
        ZStack {
            SwiftUI.Circle()
                .fill(status.color)
            buildBody()
        }.frame(width: 40, height: 40)
    }
    
    func buildBody() -> some View {
        if case .pending(let progress) = status {
            return AnyView(PendingCircle(progress: progress)
                            .padding(10.0))
        } else {
           return AnyView(Image(status.icon))
        }
    }
    
}

struct PendingCircle: View {
    let progress: CGFloat
    
    var body: some View {
        ZStack {
            SwiftUI.Circle()
                .stroke(lineWidth: 3.0)
                .opacity(0.3)
                .foregroundColor(Color(Theme.accent).opacity(0.30))
            SwiftUI.Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(Theme.accent))
                .rotationEffect(Angle(degrees: -90))
            
        }
    }
}

struct TxStatusIcon_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TxStatusIcon(status: .sent)
            TxStatusIcon(status: .received)
            TxStatusIcon(status: .pending(0.0))
            TxStatusIcon(status: .pending(0.25))
            TxStatusIcon(status: .pending(0.5))
            TxStatusIcon(status: .pending(0.75))
            TxStatusIcon(status: .pending(1.0))
            TxStatusIcon(status: .failed)
        }
    }
}
