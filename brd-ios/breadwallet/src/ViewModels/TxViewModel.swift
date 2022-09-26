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
    var tx: Transaction? { get }
    var swap: SwapDetail? { get }
    var currency: Currency? { get }
    var blockHeight: String { get }
    var longTimestamp: String { get }
    var status: TransactionStatus { get }
    var transactionType: Transaction.TransactionType { get }
    var direction: TransferDirection { get }
    var displayAddress: String { get }
    var comment: String? { get }
    var tokenTransferCode: String? { get }
    var gift: Gift? { get }
}

// Default and passthru values
extension TxViewModel {

    var currency: Currency? {
        if let tx = tx {
            return tx.currency
        } else if let swap = swap {
            return Store.state.currencies.first(where: { $0.code == swap.source.currency})
        } else {
            return nil
        }
    }
    
    var status: TransactionStatus {
        if let tx = tx {
            return tx.status
        } else if let swap = swap {
            return swap.status
        }
        return .invalid
    }
    
    var transactionType: Transaction.TransactionType {
        if let tx = tx {
            return tx.transactionType
        } else if let swap = swap {
            return swap.type
        }
        return .defaultTransaction
    }
    var direction: TransferDirection { return tx?.direction ?? .received }
    var comment: String? { return tx?.comment }
    
    // BTC does not have "from" address, only "sent to" or "received at"
    var displayAddress: String {
        guard let tx = tx else { return "" }
        
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
        return tx?.blockNumber?.description ?? L10n.TransactionDetails.notConfirmedBlockHeightLabel
    }
    
    var confirmations: String {
        return "\(tx?.confirmations ?? 0)"
    }
    
    var longTimestamp: String {
        guard let tx = tx,
              tx.timestamp > 0
        else { return L10n.Transaction.justNow }
        
        let date = Date(timeIntervalSince1970: tx.timestamp)
        return DateFormatter.longDateFormatter.string(from: date)
    }
    
    var shortTimestamp: String {
        guard let tx = tx,
              tx.timestamp > 0 else { return L10n.Transaction.justNow }
        let date = Date(timeIntervalSince1970: tx.timestamp)
        
        if date.hasEqualDay(Date()) {
            return DateFormatter.justTime.string(from: date)
        } else {
            return DateFormatter.mediumDateFormatter.string(from: date)
        }
    }
    
    var tokenTransferCode: String? {
        guard let tx = tx,
              let code = tx.metaData?.tokenTransfer,
              !code.isEmpty
        else { return nil }
        return code
    }
    
    var icon: StatusIcon {
        guard let tx = tx,
              let currency = currency else {
            return swapIcon
        }
        
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
        
        switch tx.transactionType {
        case .defaultTransaction, .buyTransaction:
            if tx.confirmations < currency.confirmationsUntilFinal {
                return .pending(CGFloat(tx.confirmations) / CGFloat(currency.confirmationsUntilFinal))
            }
            
            if tx.status == .invalid {
                return .failed
            }
            
            if tx.direction == .received || tx.direction == .recovered {
                return .received
            }
            
        case .swapTransaction:
            if tx.status == .complete {
                return .swapComplete
            }
            
            if tx.status == .pending {
                return .swapPending
            }
            
            if tx.status == .failed {
                return .failed
            }
            
        }
        
        return .sent
    }
    
    var gift: Gift? {
        return tx?.metaData?.gift
    }
    
    private var swapIcon: StatusIcon {
        guard swap != nil else {
            return .failed
        }
        
        return .swapPending
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
