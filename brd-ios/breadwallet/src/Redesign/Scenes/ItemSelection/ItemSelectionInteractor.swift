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
        guard dataStore?.items.isEmpty == false else {
            return
        }
        
        presenter?.presentData(actionResponse: .init(item: dataStore?.items ?? []))
    }
    
    func search(viewAction: ItemSelectionModels.Search.ViewAction) {
        guard let countries = dataStore?.items,
              let searchText = viewAction.text?.lowercased() else { return }
        
        let searchData = searchText.isEmpty ? countries : countries.filter { $0.displayName?.lowercased().contains(searchText) ?? false }
        presenter?.presentData(actionResponse: .init(item: Models.Item(searchData)))
    }
    // MARK: - Aditional helpers
}
