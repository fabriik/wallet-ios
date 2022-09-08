//
//  BuyInteractor.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit
import WalletKit

class BuyInteractor: NSObject, Interactor, BuyViewActions {
    typealias Models = BuyModels
    
    var presenter: BuyPresenter?
    var dataStore: BuyStore?
    
    // MARK: - BuyViewActions
    
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let currency = dataStore?.toCurrency else {
            return
        }
        
        TransferManager.shared.reload()
        
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.getExchangeRate(viewAction: .init())
                self.presenter?.presentData(actionResponse: .init(item: Models.Item(amount: .zero(currency), paymentCard: self.dataStore?.paymentCard)))
                self.presenter?.presentAssets(actionResponse: .init(amount: self.dataStore?.toAmount,
                                                                    card: self.dataStore?.paymentCard,
                                                                    quote: self.dataStore?.quote))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
        guard dataStore?.supportedCurrencies?.isEmpty != false else { return }
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.dataStore?.supportedCurrencies = currencies
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func getPaymentCards(viewAction: BuyModels.PaymentCards.ViewAction) {
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: self.dataStore?.allPaymentCards ?? []))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        let fromCode = dataStore?.fromCurrency ?? "/"
        guard let rate = dataStore?.quote?.exchangeRate,
              let toCurrency = dataStore?.toCurrency else {
            presenter?.presentError(actionResponse: .init(error: BuyErrors.noQuote(pair: "\(fromCode)-\(dataStore?.toCurrency?.code ?? "/")")))
            return
        }
        
        let to: Amount
        let from: Decimal
        if let value = viewAction.tokenValue,
           let crypto = ExchangeFormatter.crypto.number(from: value)?.decimalValue {
            
            to = .init(amount: crypto, currency: toCurrency, exchangeRate: 1 / rate)
            from = (dataStore?.to ?? 0) / rate
            dataStore?.isInputFiat = false
        } else if let value = viewAction.fiatValue,
                  let fiat = ExchangeFormatter.fiat.number(from: value)?.decimalValue {
            dataStore?.isInputFiat = true
            from = fiat
            to = .init(amount: fiat, isFiat: true, currency: toCurrency, exchangeRate: 1 / rate)
        } else {
            presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                           card: dataStore?.paymentCard,
                                                           quote: dataStore?.quote))
            return
        }
        
        dataStore?.toAmount = to
        dataStore?.from = from
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount,
                                                       card: dataStore?.paymentCard,
                                                       quote: dataStore?.quote))
    }
    
    func getExchangeRate(viewAction: Models.Rate.ViewAction) {
        guard let from = dataStore?.fromCurrency,
              let toCurrency = dataStore?.toCurrency?.code
        else { return }
        
        let data = QuoteRequestData(from: from, to: toCurrency)
        QuoteWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.dataStore?.quote = quote
                
                self?.presenter?.presentExchangeRate(actionResponse: .init(quote: quote,
                                                                           from: from,
                                                                           to: toCurrency))
                
                guard self?.dataStore?.isInputFiat == true else {
                    self?.setAmount(viewAction: .init(tokenValue: (self?.dataStore?.to ?? 0).description))
                    return
                }
                
                self?.setAmount(viewAction: .init(fiatValue: (self?.dataStore?.from ?? 0).description))
                
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
        
        getExchangeRate(viewAction: .init())
    }
    
    func showOrderPreview(viewAction: BuyModels.OrderPreview.ViewAction) {
        presenter?.presentOrderPreview(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func fetchCards(completion: ((Result<[PaymentCard]?, Error>) -> Void)?) {
        PaymentCardsWorker().execute(requestData: PaymentCardsRequestData()) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.allPaymentCards = data?.reversed()
                
                if self?.dataStore?.autoSelectDefaultPaymentMethod == true {
                    self?.dataStore?.paymentCard = self?.dataStore?.allPaymentCards?.first
                }
                
                self?.dataStore?.autoSelectDefaultPaymentMethod = true
                
            default:
                break
            }
            
            completion?(result)
        }
    }
}
