//
//  TxListViewModel.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-01-13.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit

/// View model of a transaction in list view
struct TxListViewModel: TxViewModel {
    
    // MARK: - Properties
    
    var tx: Transaction?
    var swap: SwapDetail?
    
    var shortDescription: String {
        let isComplete = tx?.status == .complete || swap?.status == .complete
        
        if let comment = comment, !comment.isEmpty {
            return comment
        } else if let tokenCode = tokenTransferCode {
            return L10n.Transaction.tokenTransfer(tokenCode.uppercased())
        } else if let tx = tx {
            var address = tx.toAddress
            var format: (Any) -> String
            
            switch tx.direction {
            case .sent, .recovered:
                format = isComplete ? L10n.Transaction.sentTo : L10n.Transaction.sendingTo
                
            case .received:
                if tx.currency.isBitcoinCompatible == false {
                    format = isComplete ? L10n.TransactionDetails.receivedFrom : L10n.TransactionDetails.receivingFrom
                    address = tx.fromAddress
                } else {
                    format = isComplete ? L10n.TransactionDetails.receivedVia : L10n.TransactionDetails.receivingVia
                }
            }
            return format(address)
            
        } else if let swap = swap {
            return L10n.TransactionDetails.receivedFrom(swap.source.transactionId ?? "")
        } else {
            return ""
        }
    }

    func amount(showFiatAmounts: Bool, rate: Rate) -> NSAttributedString {
        // TODO: handle swap amount
        if let tx = tx {
            var amount = tx.amount

            if tokenTransferCode != nil {
                // this is the originating tx of a token transfer, so the amount is 0 but we want to show the fee
                amount = tx.fee
            }

            let text = Amount(amount: amount,
                              rate: showFiatAmounts ? rate : nil,
                              negative: (tx.direction == .sent)).description
            let color: UIColor = (tx.direction == .received) ? .receivedGreen : .darkGray
            
            return NSMutableAttributedString(string: text,
                                             attributes: [.foregroundColor: color])
        } else if let swap = swap {
            let isSedning = swap.source.currency == currency?.code
            let color: UIColor = isSedning ? .darkGray :.receivedGreen
            
            return NSMutableAttributedString(string: "\(swap.source.currencyAmount.description) \(swap.source.currency)",
                                             attributes: [.foregroundColor: color])
        } else {
            return .init()
        }
    }
}
