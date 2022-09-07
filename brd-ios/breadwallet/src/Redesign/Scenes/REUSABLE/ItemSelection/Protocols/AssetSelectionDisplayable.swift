// 
//  AssetSelectionDisplayable.swift
//  breadwallet
//
//  Created by Rok on 18/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

protocol AssetSelectionDisplayable {
    func showAssetSelector(currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?)
    func isDisabledAsset(code: String?, supportedCurrencies: [SupportedCurrency]?) -> Bool?
}

extension AssetSelectionDisplayable where Self: BaseCoordinator {
    func showAssetSelector(currencies: [Currency]?, supportedCurrencies: [SupportedCurrency]?, selected: ((Any?) -> Void)?) {
        let allCurrencies = CurrencyFileManager().getCurrencyMetaDataFromCache()
        
        let supportedAssets = allCurrencies.filter { item in supportedCurrencies?.contains(where: { $0.name.lowercased() == item.code}) ?? false }
        
        var data: [AssetViewModel]? = currencies?.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code,
                                  topRightText: HomeScreenAssetViewModel(currency: $0).tokenBalance,
                                  bottomRightText: HomeScreenAssetViewModel(currency: $0).fiatBalance,
                                  isDisabled: isDisabledAsset(code: $0.code, supportedCurrencies: supportedCurrencies) ?? false)
        }
        
        let unsupportedAssets = supportedAssets.filter { item in !(data?.contains(where: { $0.subtitle?.lowercased() == item.code }) ?? false) }
        
        let disabledData: [AssetViewModel]? = unsupportedAssets.compactMap {
            return AssetViewModel(icon: $0.imageSquareBackground,
                                  title: $0.name,
                                  subtitle: $0.code.uppercased(),
                                  isDisabled: true)
        }
        
        data?.append(contentsOf: disabledData ?? [])
        
        let sortedCurrencies = data?.sorted { !$0.isDisabled && $1.isDisabled }
        
        openModally(coordinator: ItemSelectionCoordinator.self,
                    scene: Scenes.AssetSelection,
                    presentationStyle: .formSheet) { vc in
            vc?.dataStore?.items = sortedCurrencies ?? []
            vc?.itemSelected = selected
            vc?.prepareData()
        }
    }
    
    func isDisabledAsset(code: String?, supportedCurrencies: [SupportedCurrency]?) -> Bool? {
        guard let assetCode = code else { return false }
        
        return !(supportedCurrencies?.contains(where: { $0.name == assetCode}) ?? false)
    }
}
