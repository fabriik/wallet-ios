//
//  AssetSelectionViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

class AssetSelectionViewController: ItemSelectionViewController {
    
    override var sceneTitle: String? { return "Select assets" }
    
    override func setupSubviews() {
        super.setupSubviews()
        tableView.register(WrapperTableViewCell<AssetView>.self)
    }
    
    override func tableView(_ tableView: UITableView, itemCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<AssetView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? AssetViewModel
        else {
            return UITableViewCell()
        }
        
        cell.setup { view in
            let enabledConfig = Presets.Asset.Enabled
            let disabledConfig = Presets.Asset.Disabled
            
            view.configure(with: model.isDisabled ? disabledConfig : enabledConfig)
            view.setup(with: model)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? AssetViewModel,
              model.isDisabled == false
        else { return }
        
        itemSelected?(model)
        coordinator?.goBack()
    }

    // MARK: - User Interaction

    // MARK: - AssetSelectionResponseDisplay

    // MARK: - Additional Helpers
}
