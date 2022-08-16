//
//  BuyInteractor.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

enum BuyErrors: FEError {
    case noQuote
    
    var errorMessage: String {
        switch self {
        case .noQuote:
            return "no quote"
        }
    }
}

class BuyInteractor: NSObject, Interactor, BuyViewActions {
    typealias Models = BuyModels

    var presenter: BuyPresenter?
    var dataStore: BuyStore?

    // MARK: - BuyViewActions

    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let currency = dataStore?.toCurrency else {
            return
        }
        
        dataStore?.to = 0
        
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.dataStore?.allPaymentCards = data
                
                self.getExchangeRate(viewAction: .init())
                self.presenter?.presentData(actionResponse: .init(item: Models.Item(amount: .zero(currency), paymentCard: self.dataStore?.paymentCard)))
                self.presenter?.presentAssets(actionResponse: .init(amount: self.dataStore?.toAmount, card: self.dataStore?.paymentCard))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        guard let rate = dataStore?.quote?.exchangeRate else {
            presenter?.presentError(actionResponse: .init(error: BuyErrors.noQuote))
            return
        }
        
        if let value = viewAction.tokenValue {
            dataStore?.to = decimalFor(amount: value)
            dataStore?.from = (dataStore?.to ?? 0) / rate
        } else if let value = viewAction.fiatValue {
            dataStore?.from = decimalFor(amount: value)
            dataStore?.to = (dataStore?.from ?? 0) * rate
        }
        
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount, card: dataStore?.paymentCard))   
    }
    
    func getExchangeRate(viewAction: Models.Rate.ViewAction) {
        guard let from = dataStore?.fromCurrency,
              let to = dataStore?.toCurrency?.code else {
            return
        }
        
        let data = QuoteRequestData(from: from, to: to)
        QuoteWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.dataStore?.quote = quote
                self?.presenter?.presentExchangeRate(actionResponse: .init(from: from,
                                                                           to: to,
                                                                           rate: quote.exchangeRate,
                                                                           expires: quote.timestamp + 60))
                self?.setAmount(viewAction: .init(tokenValue: self?.dataStore?.toAmount?.tokenValue.description))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAssets(viewAction: BuyModels.Assets.ViewAction) {
        if let value = viewAction.currency?.lowercased(),
           let currency = Store.state.currencies.first(where: { $0.code.lowercased() == value }) {
            dataStore?.toCurrency = currency
        } else if let value = viewAction.card {
            dataStore?.paymentCard = value
        }
        
        getData(viewAction: .init())
    }
    
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction) {
        presenter?.presentOrderPreview(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    // TODO: extract to helper class
    private func decimalFor(amount: String?) -> Decimal? {
        guard let amount = amount else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8 //Int(currency.baseUnit.decimals)
        
        return formatter.number(from: amount)?.decimalValue
    }
    
    private func formatAmount(amount: Decimal?) -> String? {
        guard let amount = amount else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8 //Int(currency.baseUnit.decimals)
        
        return formatter.string(for: amount)
    }
}
