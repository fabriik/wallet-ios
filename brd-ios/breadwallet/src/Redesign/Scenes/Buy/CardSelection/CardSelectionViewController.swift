// 
//  CardSelectionViewController.swift
//  breadwallet
//
//  Created by Rok on 02/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

extension Scenes {
    static let CardSelection = CardSelectionViewController.self
}

class CardSelectionViewController: ItemSelectionViewController {
    
    // TODO: localize
    override var sceneTitle: String? { return "Select payment method" }
    override var isSearchEnabled: Bool { return false }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.separatorStyle = .none
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
    }
    
    override func tableView(_ tableView: UITableView, itemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? PaymentCard
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init(title: nil,
                                   subtitle: nil,
                                   logo: model.displayImage,
                                   cardNumber: .text(model.displayName),
                                   expiration: .text(CardDetailsFormatter.formatExpirationDate(month: model.expiryMonth, year: model.expiryYear))))
            
            view.setupCustomMargins(top: .zero, leading: .large, bottom: .zero, trailing: .large)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, addItemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath) else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init(title: .text("Card"),
                                   subtitle: nil,
                                   logo: .imageName("credit_card_icon"),
                                   cardNumber: .text("Add a debit or credit card"),
                                   expiration: nil))
            
            view.setupCustomMargins(top: .zero, leading: .large, bottom: .zero, trailing: .large)
        }
        
        return cell
    }
}
