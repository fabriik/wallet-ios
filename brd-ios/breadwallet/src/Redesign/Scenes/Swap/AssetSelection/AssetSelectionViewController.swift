//
//  AssetSelectionViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

extension Scenes {
    static let AssetSelection = AssetSelectionViewController.self
}

class AssetSelectionViewController: ItemSelectionViewController {
    
    override var sceneTitle: String? { return L10n.Swap.selectAssets }
    
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
            view.configure(with: model.isDisabled ? Presets.Asset.disabled : Presets.Asset.enabled)
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
        
        coordinator?.dismissFlow()
    }

    // MARK: - User Interaction

    // MARK: - AssetSelectionResponseDisplay

    // MARK: - Additional Helpers
}
