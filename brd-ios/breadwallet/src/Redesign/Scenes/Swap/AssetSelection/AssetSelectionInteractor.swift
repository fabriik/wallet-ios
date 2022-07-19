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
                                  subtitle: $0.code,
                                  isDisabled: isDisabledAsset(code: $0.code) ?? false) } ?? []
        
        let sortedCurrencies = currencies.sorted { !$0.isDisabled && $1.isDisabled }
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(sortedCurrencies)))
    }
    
    func search(viewAction: Models.Search.ViewAction) {
        guard let searchText = viewAction.text?.lowercased() else { return }
        let items = dataStore?.currencies
        let searchData = searchText.isEmpty ? items : items?.filter { $0.name.lowercased().contains(searchText) }
        
        let searchCurrencies = searchData?.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code) } ?? []
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(searchCurrencies)))
    }
    
    private func isDisabledAsset(code: String?) -> Bool? {
        guard let assetCode = code else { return false }
        
        return !(dataStore?.assets.contains(assetCode) ?? false)
    }
    
    // MARK: - Aditional helpers
}
