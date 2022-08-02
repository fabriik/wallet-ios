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
    
    override func setupSubviews() {
        super.setupSubviews()
        tableView.register(WrapperTableViewCell<CardSelectionView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<CardSelectionView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? PaymentCard
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: .init(title: nil, logo: model.displayImage, cardNumber: .text(model.number), expiration: .text(model.expiration)))
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? PaymentCard else { return }
        itemSelected?(model)
        coordinator?.goBack()
    }
}
