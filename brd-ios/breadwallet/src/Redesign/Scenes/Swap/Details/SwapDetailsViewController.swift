//
//  SwapDetailsViewController.swift
//  breadwallet
//
//  Created by Rok on 06/07/2022.
//
//

import UIKit

class SwapDetailsViewController: BaseTableViewController<BaseCoordinator,
                                 SwapDetailsInteractor,
                                 SwapDetailsPresenter,
                                 SwapDetailsStore>,
                                 SwapDetailsResponseDisplays {
    
    typealias Models = SwapDetailsModels
    
    override var sceneLeftAlignedTitle: String? {
        return "Swap details"
    }

    // MARK: - Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        tableView.register(WrapperTableViewCell<AssetView>.self)
        tableView.register(WrapperTableViewCell<OrderView>.self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section] as? Models.Section
        
        let cell: UITableViewCell
        switch section {
        case .header, .toCurrency, .fromCurrency:
            cell = self.tableView(tableView, headerCellForRowAt: indexPath)
            
        case .order, .transactionID:
            cell = self.tableView(tableView, orderCellForRowAt: indexPath)
       
        case .none:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(vertical: .small, horizontal: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, headerCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<AssetView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? AssetViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: Presets.Asset.Header)
            view.setup(with: model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, orderCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<OrderView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? OrderViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            view.configure(with: .init())
            view.setup(with: model)
            view.copyCallback = { [weak self] code in
                self?.coordinator?.showMessage(model: InfoViewModel(description: .text(code), dismissType: .auto),
                                               configuration: Presets.InfoView.error)
            }
        }
        
        return cell
    }

    // MARK: - User Interaction

    // MARK: - SwapDetailsResponseDisplay

    // MARK: - Additional Helpers
}
