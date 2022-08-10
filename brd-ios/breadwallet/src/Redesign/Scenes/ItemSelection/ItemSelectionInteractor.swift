//
//  ItemSelectionInteractor.swift
//  breadwallet
//
//  Created by Rok on 31/05/2022.
//
//

import UIKit

class ItemSelectionInteractor: NSObject, Interactor, ItemSelectionViewActions {
    typealias Models = ItemSelectionModels

    var presenter: ItemSelectionPresenter?
    var dataStore: ItemSelectionStore?

    // MARK: - ItemSelectionViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let items = dataStore?.items,
              items.isEmpty == false,
              let isAddingEnabled = dataStore?.isAddingEnabled else { return }
        
        let item = Models.Item(items: items, isAddingEnabled: isAddingEnabled)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func search(viewAction: ItemSelectionModels.Search.ViewAction) {
        guard let items = dataStore?.items,
              let searchText = viewAction.text?.lowercased() else { return }
        
        let searchData = searchText.isEmpty ? items : items.filter { $0.displayName?.lowercased().contains(searchText) ?? false }
        let item = Models.Item(items: searchData, isAddingEnabled: dataStore?.isAddingEnabled)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    // MARK: - Aditional helpers
}
