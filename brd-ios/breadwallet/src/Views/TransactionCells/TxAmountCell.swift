//
//  TxAmountCell.swift
//  breadwallet
//
//  Created by Ehsan Rezaie on 2017-12-21.
//  Copyright © 2017-2019 Breadwinner AG. All rights reserved.
//

import UIKit

class TxAmountCell: UITableViewCell, Subscriber {
    
    // MARK: - Vars
    
    private let container = UIView()
    private lazy var tokenAmountLabel: UILabel = {
        let label = UILabel(font: Fonts.Title.five)
        label.textColor = LightColors.secondary
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var fiatAmountLabel: UILabel = {
        let label = UILabel(font: Fonts.Body.one)
        label.textColor = LightColors.Text.two
        label.textAlignment = .center
        return label
    }()
    private let separator = UIView(color: LightColors.Outline.one)
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(container)
        contentView.addSubview(separator)
        container.addSubview(fiatAmountLabel)
        container.addSubview(tokenAmountLabel)
    }
    
    private func addConstraints() {
        container.constrain(toSuperviewEdges: UIEdgeInsets(top: Margins.small.rawValue,
                                                           left: Margins.large.rawValue,
                                                           bottom: -Margins.large.rawValue,
                                                           right: -Margins.large.rawValue))
        
        tokenAmountLabel.constrain([
            tokenAmountLabel.constraint(.top, toView: container),
            tokenAmountLabel.constraint(.leading, toView: container),
            tokenAmountLabel.constraint(.trailing, toView: container)
            ])
        fiatAmountLabel.constrain([
            fiatAmountLabel.constraint(toBottom: tokenAmountLabel),
            fiatAmountLabel.constraint(.leading, toView: container),
            fiatAmountLabel.constraint(.trailing, toView: container),
            fiatAmountLabel.constraint(.bottom, toView: container)
            ])
        
        separator.constrainBottomCorners(height: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(viewModel: TxDetailViewModel) {
        tokenAmountLabel.text = viewModel.amount
        // fiat amount label
        let currentAmount = viewModel.fiatAmount
        let originalAmount = viewModel.originalFiatAmount
        
        if viewModel.status != .complete || originalAmount == nil {
            fiatAmountLabel.text = currentAmount
        } else {
            guard let originalAmount = originalAmount else { return }
            let format = (viewModel.direction == .sent) ? L10n.TransactionDetails.amountWhenSent : L10n.TransactionDetails.amountWhenReceived
            let string = format(originalAmount, currentAmount)
            
            fiatAmountLabel.text = currentAmount
        }
    }
}
