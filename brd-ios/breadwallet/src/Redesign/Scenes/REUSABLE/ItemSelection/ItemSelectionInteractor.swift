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
    
    func removePayment(viewAction: ItemSelectionModels.RemovePayment.ViewAction) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                DeleteCardWorker().execute(requestData: DeleteCardRequestData(instrumentId: data?[0].id)) { [weak self] result in
                        switch result {
                        case .success(let data):
                            print(data)
                            self?.presenter?.presentRemovePaymentMessage(actionResponse: .init())
                            
                        case .failure(let error):
                            self?.presenter?.presentError(actionResponse: .init(error: error))
                        }
                    }
            
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func removePaymenetPopup(viewAction: ItemSelectionModels.RemovePaymenetPopup.ViewAction) {
        presenter?.presentRemovePaymentPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
}
