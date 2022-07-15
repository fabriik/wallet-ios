//
//  AssetSelectionViewController.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

class AssetSelectionViewController: BaseTableViewController<SwapCoordinator,
                                    AssetSelectionInteractor,
                                    AssetSelectionPresenter,
                                    AssetSelectionStore>,
                                    AssetSelectionResponseDisplays, UISearchResultsUpdating, UISearchBarDelegate {
    
    typealias Models = AssetSelectionModels
    var searchController = UISearchController()
    var itemSelected: ((Any?) -> Void)?

    // MARK: - Overrides
    override func setupSubviews() {
        super.setupSubviews()
        
        navigationItem.title = "Select assets"
        
        tableView.separatorInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.register(WrapperTableViewCell<AssetView>.self)
        
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.sizeToFit()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    @objc override func dismissModal() {
        super.dismissModal()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section] as? Models.Sections {
        case .items:
            cell = self.tableView(tableView, assetCellForRowAt: indexPath)
        default:
            cell = UITableViewCell()
        }
        
        cell.setupCustomMargins(all: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, assetCellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<AssetView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? AssetViewModel
        else {
            return UITableViewCell()
        }
        
        let isDisabled = model.isDisabled ?? false
        cell.setup { view in
            isDisabled ? view.configure(with: Presets.Asset.Disabled) : view.configure(with: Presets.Asset.Enabled)
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
    
    // MARK: - Search View Delegate
    func updateSearchResults(for searchController: UISearchController) {}
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            interactor?.getData(viewAction: .init())
            return
        }
        
        search(searchText)
    }
    
    func search(_ text: String) {
        interactor?.search(viewAction: .init(text: text))
    }

    // MARK: - User Interaction

    // MARK: - AssetSelectionResponseDisplay

    // MARK: - Additional Helpers
}
