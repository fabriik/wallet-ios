//
//  AssetSelectionInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.7.22.
//
//

import UIKit

class AssetSelectionInteractor: NSObject, Interactor, AssetSelectionViewActions {
    
    typealias Models = AssetSelectionModels

    var presenter: AssetSelectionPresenter?
    var dataStore: AssetSelectionStore?

    // MARK: - AssetSelectionViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        let currencies = dataStore?.currencies.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code) } ?? []
        presenter?.presentData(actionResponse: .init(item: Models.Item(currencies)))
    }
    
    func search(viewAction: Models.Search.ViewAction) {
        guard let searchText = viewAction.text?.lowercased() else { return }
        let items = dataStore?.currencies
        let searchData = searchText.isEmpty ? items : items?.filter { $0.name.lowercased().contains(searchText) as? Bool ?? false }
        
        presenter?.presentData(actionResponse: .init(item: Models.Item([])))
    }

    // MARK: - Aditional helpers
}
