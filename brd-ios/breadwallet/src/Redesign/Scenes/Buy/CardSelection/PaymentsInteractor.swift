//
//  PaymentsInteractor.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

class PaymentsInteractor: NSObject, Interactor, PaymentsViewActions {
    typealias Models = PaymentsModels

    var presenter: PaymentsPresenter?
    var dataStore: PaymentsStore?
    
    // MARK: - PaymentsViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let items = dataStore?.items,
              items.isEmpty == false,
              let isAddingEnabled = dataStore?.isAddingEnabled else { return }
        
        let item = Models.Item(items: items, isAddingEnabled: isAddingEnabled)
        presenter?.presentData(actionResponse: .init(item: item))
    }
    
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction) {
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                guard let items = self.dataStore?.items,
                      items.isEmpty == false,
                      let isAddingEnabled = self.dataStore?.isAddingEnabled else { return }
                
                let item = Models.Item(items: items, isAddingEnabled: isAddingEnabled)
                self.presenter?.presentData(actionResponse: .init(item: item))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func showActionSheetRemovePayment(viewAction: PaymentsModels.ActionSheet.ViewAction) {
        presenter?.presentActionSheetRemovePayment(actionResponse: .init(instrumentId: viewAction.instrumentId))
    }
    
    func removePayment(viewAction: PaymentsModels.RemovePayment.ViewAction) {
        DeleteCardWorker().execute(requestData: DeleteCardRequestData(instrumentId: self.dataStore?.instrumentID)) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentRemovePaymentMessage(actionResponse: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func removePaymenetPopup(viewAction: PaymentsModels.RemovePaymenetPopup.ViewAction) {
        dataStore?.instrumentID = viewAction.instrumentID
        presenter?.presentRemovePaymentPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func fetchCards(completion: ((Result<[PaymentCard]?, Error>) -> Void)?) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.items = data?.reversed()
                
            default:
                break
            }
            
            completion?(result)
        }
    }
}
