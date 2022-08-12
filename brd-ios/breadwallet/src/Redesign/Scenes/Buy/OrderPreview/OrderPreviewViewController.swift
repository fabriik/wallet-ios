//
//  OrderPreviewViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 12.8.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

class OrderPreviewViewController: BaseTableViewController<BuyCoordinator,
                                  OrderPreviewInteractor,
                                  OrderPreviewPresenter,
                                  OrderPreviewStore>,
                                  OrderPreviewResponseDisplays {
    typealias Models = OrderPreviewModels
    
    override var sceneTitle: String? {
        // TODO: Localize
        return "Order preview"
    }

    // MARK: - Overrides
    
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<BuyOrderView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .orderInfoCard:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .payment:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .termsAndConditions:
            cell = self.tableView(tableView, labelCellForRowAt: indexPath)
            
        case .confirm:
            cell = self.tableView(tableView, buttonCellForRowAt: indexPath)
            
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
        return cell
    }

    // MARK: - User Interaction
    
    @objc override func buttonTapped() {
        super.buttonTapped()
        
      //  interactor?.submit(viewAction: .init())
    }

    // MARK: - OrderPreviewResponseDisplay

    // MARK: - Additional Helpers
}
