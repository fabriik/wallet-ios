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
    
    // TODO: Remove the mock data
    let items = [ AssetViewModel(icon: .image(TokenImageSquareBackground(code: "BTC", color: .red).renderedImage ?? UIImage()),
                                 title: "Bitcoin",
                                 subtitle: "BTC",
                                 topRightText: "3 BTC",
                                 bottomRightText: "$2.523",
                                 isDisabled: false),
                  AssetViewModel(icon: .image(TokenImageSquareBackground(code: "BTC", color: .red).renderedImage ?? UIImage()),
                                 title: "Ethereum",
                                 subtitle: "ETH",
                                 topRightText: "0.5612 ETH",
                                 bottomRightText: "$220.52",
                                 isDisabled: true) ]

    // MARK: - AssetSelectionViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        presenter?.presentData(actionResponse: .init(item: Models.Item(items)))
    }
    
    func search(viewAction: Models.Search.ViewAction) {
        guard let searchText = viewAction.text?.lowercased() else { return }
        
        let searchData = searchText.isEmpty ? items : items.filter { $0.title?.lowercased().contains(searchText) as? Bool ?? false }
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(searchData)))
    }

    // MARK: - Aditional helpers
}
