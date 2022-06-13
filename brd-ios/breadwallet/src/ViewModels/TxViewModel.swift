//
//  TxViewModel.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-11.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import Foundation
import WalletKit
import UIKit

/// Representation of a transaction
protocol TxViewModel {
    var tx: Transaction { get }
    var currency: Currency { get }
    var blockHeight: String { get }
    var longTimestamp: String { get }
    var status: TransactionStatus { get }
    var direction: TransferDirection { get }
    var displayAddress: String { get }
    var comment: String? { get }
    var tokenTransferCode: String? { get }
    var gift: Gift? { get }
}

// Default and passthru values
extension TxViewModel {

    var currency: Currency { return tx.currency }
    var status: TransactionStatus { return tx.status }
    var direction: TransferDirection { return tx.direction }
    var comment: String? { return tx.comment }
    
    // BTC does not have "from" address, only "sent to" or "received at"
    var displayAddress: String {
        if !tx.currency.isBitcoinCompatible {
            if direction == .sent {
                return tx.toAddress
            } else {
                return tx.fromAddress
            }
        } else {
            return tx.toAddress
        }
    }
    
    var blockHeight: String {
        return tx.blockNumber?.description ?? L10n.TransactionDetails.notConfirmedBlockHeightLabel
    }
    
    var confirmations: String {
        return "\(tx.confirmations)"
    }
    
    var longTimestamp: String {
        guard tx.timestamp > 0 else { return tx.isValid ? L10n.Transaction.justNow : "" }
        let date = Date(timeIntervalSince1970: tx.timestamp)
        return DateFormatter.longDateFormatter.string(from: date)
    }
    
    var shortTimestamp: String {
        guard tx.timestamp > 0 else { return tx.isValid ? L10n.Transaction.justNow : "" }
        let date = Date(timeIntervalSince1970: tx.timestamp)
        
        if date.hasEqualDay(Date()) {
            return DateFormatter.justTime.string(from: date)
        } else if date.hasEqualYear(Date()) {
            return DateFormatter.shortDateFormatter.string(from: date)
        } else {
            return DateFormatter.mediumDateFormatter.string(from: date)
        }
    }
    
    var tokenTransferCode: String? {
        guard let code = tx.metaData?.tokenTransfer, !code.isEmpty else { return nil }
        return code
    }
    
    var icon: StatusIcon {
        if let gift = gift, tx.confirmations >= currency.confirmationsUntilFinal {
            //not shared should override unclaimed
            if gift.reclaimed == true {
                return .gift(.reclaimed)
            } else if gift.claimed {
                return .gift(.claimed)
            } else if gift.shared == false {
                return .gift(.unsent)
            } else {
                return .gift(.unclaimed)
            }
        }
        
        if tx.confirmations < currency.confirmationsUntilFinal {
            return .pending(CGFloat(tx.confirmations)/CGFloat(currency.confirmationsUntilFinal))
        }
        
        if tx.status == .invalid {
            return .failed
        }
        
        if tx.direction == .received || tx.direction == .recovered {
            return .received
        }
        
        return .sent
    }
    
    var gift: Gift? {
        return tx.metaData?.gift
    }
}

// MARK: - Formatting

extension DateFormatter {
    static let longDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMMM d, yyy h:mm a")
        return df
    }()
    
    static let justTime: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("h:mm a")
        return df
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d")
        return df
    }()

    static let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        return df
    }()
}

private extension String {
    var smallCondensed: String {
        let start = String(self[..<index(startIndex, offsetBy: 5)])
        let end = String(self[index(endIndex, offsetBy: -5)...])
        return start + "..." + end
    }
    
    var largeCondensed: String {
        let start = String(self[..<index(startIndex, offsetBy: 10)])
        let end = String(self[index(endIndex, offsetBy: -10)...])
        return start + "..." + end
    }
}
