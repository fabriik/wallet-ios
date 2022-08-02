//
//  ItemSelectionViewController.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionViewController: BaseTableViewController<ItemSelectionCoordinator,
                                   ItemSelectionInteractor,
                                   ItemSelectionPresenter,
                                   ItemSelectionStore>,
                                   ItemSelectionResponseDisplays,
                                   UISearchResultsUpdating,
                                   UISearchBarDelegate {
    typealias Models = ItemSelectionModels
    
    var itemSelected: ((Any?) -> Void)?
    var searchController = UISearchController()
    
    // MARK: - Overrides
    
    override func prepareData() {
        super.prepareData()
        
        DispatchQueue.main.async {
            LoadingView.show()
        }
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        navigationItem.title = "Country"
        
        tableView.separatorInset = .zero
        tableView.separatorStyle = .singleLine
        tableView.register(WrapperTableViewCell<ItemView>.self)
        
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
        itemSelected?(nil)
        super.dismissModal()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell: WrapperTableViewCell<ItemView> = tableView.dequeueReusableCell(for: indexPath),
              let model = sectionRows[section]?[indexPath.row] as? ItemSelectable
        else { return UITableViewCell() }
        
        cell.setup { view in
            view.setup(with: .init(title: model.displayName ?? "", image: model.displayImage))
            view.setupCustomMargins(all: .large)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        guard let model = sectionRows[section]?[indexPath.row] as? Model else { return }
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

    // MARK: - ItemSelectionResponseDisplay

    // MARK: - Additional Helpers
}
