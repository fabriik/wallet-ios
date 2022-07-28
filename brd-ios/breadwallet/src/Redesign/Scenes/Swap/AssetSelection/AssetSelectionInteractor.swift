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
        let currencies = dataStore?.currencies?.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code,
                                  topRightText: HomeScreenAssetViewModel(currency: $0).tokenBalance,
                                  bottomRightText: HomeScreenAssetViewModel(currency: $0).fiatBalance,
                                  isDisabled: isDisabledAsset(code: $0.code, from: dataStore?.isFromCurrency) ?? false) } ?? []
        
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
                                  subtitle: $0.code,
                                  topRightText: HomeScreenAssetViewModel(currency: $0).tokenBalance,
                                  bottomRightText: HomeScreenAssetViewModel(currency: $0).fiatBalance,
                                  isDisabled: isDisabledAsset(code: $0.code, from: dataStore?.isFromCurrency) ?? false) } ?? []
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(searchCurrencies)))
    }
    
    private func isDisabledAsset(code: String?, from: Bool? = false) -> Bool? {
        guard let assetCode = code else { return false }
        
        var supportedAssets: [String]?
        guard let isFromCurrency = from else { return false }
        
        if isFromCurrency {
            supportedAssets = dataStore?.supportedCurrenciesPair?.filter { $0.contains(assetCode) }
        } else {
            let supportedCurrenciesPair = dataStore?.supportedCurrenciesPair?.filter { $0.contains(dataStore?.baseCurrencySelected?.code ?? "") }
            guard dataStore?.baseCurrencySelected?.code != assetCode else { return true }
            
            supportedAssets = supportedCurrenciesPair?.filter { $0.contains(assetCode) }
        }
        
        return supportedAssets?.isEmpty
    }
    
    // MARK: - Aditional helpers
}
