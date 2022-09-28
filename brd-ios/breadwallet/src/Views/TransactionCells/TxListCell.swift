//
//  TxListCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2018-02-19.
//  Copyright © 2018-2019 Breadwinner AG. All rights reserved.
//

import UIKit
import SwiftUI

// TODO: Fix completeConstraints/pendingConstraints logic and other visible UI bugs. 

class TxListCell: UITableViewCell {

    // MARK: - Views
    
    private let iconImageView = UIImageView()
    private let timestamp = UILabel(font: .customBody(size: 16.0), color: .darkGray)
    private let descriptionLabel = UILabel(font: .customBody(size: 14.0), color: .lightGray)
    private let amount = UILabel(font: .customBold(size: 18.0))
    private let separator = UIView(color: .separatorGray)
    
    // MARK: Vars
    
    private var viewModel: TxListViewModel!
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setTransaction(_ viewModel: TxListViewModel, showFiatAmounts: Bool, rate: Rate, isSyncing: Bool) {
        self.viewModel = viewModel
        iconImageView.image = .init(named: viewModel.icon.icon)
        descriptionLabel.text = viewModel.shortDescription
        amount.attributedText = viewModel.amount(showFiatAmounts: showFiatAmounts, rate: rate)
        
        switch viewModel.transactionType {
        case .defaultTransaction:
            handleDefaultTransactions()
            
        case .swapTransaction:
            handleSwapTransactions()
            
        case .buyTransaction:
            handleBuyTransactions()
        }
        
        layoutSubviews()
    }
    
    private func handleDefaultTransactions() {
        switch viewModel.status {
        case .invalid:
            timestamp.text = L10n.Transaction.failed
            timestamp.isHidden = false
            
        case .complete:
            timestamp.text = viewModel.shortTimestamp
            timestamp.isHidden = false
            
        default:
            timestamp.isHidden = false
            
            guard let currency = viewModel.currency else { return }
            timestamp.text = "\(viewModel.confirmations)/\(currency.confirmationsUntilFinal) " + L10n.TransactionDetails.confirmationsLabel
        }
    }
    
    private func handleBuyTransactions() {
        switch viewModel.status {
        case .invalid:
            timestamp.text = L10n.Transaction.purchaseFailed
            timestamp.isHidden = false
            
        case .refunded:
            timestamp.text = L10n.Transaction.refunded
            timestamp.isHidden = false
            
        case .complete, .manuallySettled, .confirmed:
            timestamp.text = L10n.Transaction.purchased
            timestamp.isHidden = false
            
        default:
            timestamp.text = L10n.Transaction.pendingPurchase
            timestamp.isHidden = false
        }
    }
    
    private func handleSwapTransactions() {
        let isSwapTo = viewModel.tx?.swapSource?.currency.uppercased() == viewModel.currency?.code.uppercased()
        let swapString: String
        if let tx = viewModel.tx {
            swapString = isSwapTo ? "to \(tx.swapDestination?.currency.uppercased() ?? "")" : "from \(tx.swapSource?.currency.uppercased() ?? "")"
        } else if let swap = viewModel.swap {
            swapString = isSwapTo ? "to \(swap.destination.currency.uppercased())" : "from \(swap.source.currency.uppercased())"
        } else {
            return
        }
        
        switch viewModel.status {
        case .complete, .manuallySettled:
            timestamp.text = "\(L10n.Transaction.swapped) \(swapString)"
            timestamp.isHidden = false
            
        case .pending:
            timestamp.text = "\(L10n.Transaction.pendingSwap) \(swapString)"
            timestamp.isHidden = false
            
        case .failed:
            timestamp.text = "\(L10n.Transaction.failedSwap) \(swapString)"
            timestamp.isHidden = false
        
        case .refunded:
            timestamp.text = L10n.Transaction.refunded
            timestamp.isHidden = false
            
        default:
            break
        }
    }
    
    // MARK: - Private
    
    private func setupViews() {
        addSubviews()
        addConstraints()
        setupStyle()
    }
    
    private func addSubviews() {
        contentView.addSubview(iconImageView)
        iconImageView.contentMode = .scaleAspectFill
        contentView.addSubview(timestamp)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(amount)
        contentView.addSubview(separator)
    }
    
    private func addConstraints() {
        iconImageView.constrain([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: C.padding[2]),
            iconImageView.widthAnchor.constraint(equalToConstant: FieldHeights.common.rawValue),
            iconImageView.heightAnchor.constraint(equalToConstant: FieldHeights.common.rawValue),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        timestamp.constrain([
            timestamp.topAnchor.constraint(equalTo: contentView.topAnchor, constant: C.padding[2]),
            timestamp.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: C.padding[2])])
        descriptionLabel.constrain([
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -C.padding[2]),
            descriptionLabel.leadingAnchor.constraint(equalTo: timestamp.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: amount.leadingAnchor, constant: -C.padding[2])
        ])
        descriptionLabel.constrain([
            descriptionLabel.topAnchor.constraint(equalTo: timestamp.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: timestamp.leadingAnchor)
        ])
        amount.constrain([
            amount.topAnchor.constraint(equalTo: contentView.topAnchor),
            amount.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            amount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -C.padding[2])])
        separator.constrainBottomCorners(height: 0.5)
    }
    
    private func setupStyle() {
        selectionStyle = .none
        amount.textAlignment = .right
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        descriptionLabel.lineBreakMode = .byTruncatingTail
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
