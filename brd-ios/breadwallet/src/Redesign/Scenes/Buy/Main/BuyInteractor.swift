//
//  BuyInteractor.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

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
            case .success(let data):
                self.presenter?.presentPaymentCards(actionResponse: .init(allPaymentCards: data ?? []))
                
            case .failure(let error):
                self.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        guard let rate = dataStore?.quote?.exchangeRate else {
            let toCode = dataStore?.toCurrency?.code ?? "/"
            let fromCode = dataStore?.fromCurrency ?? "/"
            presenter?.presentError(actionResponse: .init(error: BuyErrors.noQuote(pair: "\(fromCode)-\(toCode)")))
            return
        }
        
        if let value = viewAction.tokenValue {
            dataStore?.to = ExchangeFormatter.crypto.number(from: value)?.decimalValue
            dataStore?.from = (dataStore?.to ?? 0) / rate
            dataStore?.isInputFiat = false
        } else if let value = viewAction.fiatValue {
            dataStore?.isInputFiat = true
            dataStore?.from = ExchangeFormatter.fiat.number(from: value)?.decimalValue
            dataStore?.to = (dataStore?.from ?? 0) * rate
        }
        
        getFees()
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
    
    private func getFees() {
        guard let to = dataStore?.toAmount,
              let wallet = dataStore?.coreSystem?.wallet(for: to.currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore?.keyStore,
              let address = dataStore?.address(for: to.currency),
              let value = dataStore?.amountFrom(decimal: to.tokenValue, currency: to.currency)
        else { return }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        sender.estimateFee(address: address,
                           amount: value,
                           tier: .regular,
                           isStake: false) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.ethFee = nil
                self?.dataStore?.toFee = fee
                
                self?.presenter?.presentAssets(actionResponse: .init(amount: self?.dataStore?.toAmount,
                                                                     card: self?.dataStore?.paymentCard,
                                                                     quote: self?.dataStore?.quote))
                
            case .failure(let error):
                guard to.currency.isEthereumCompatible == true else {
                    self?.presenter?.presentError(actionResponse: .init(error: error))
                    return
                }
                let address = self?.dataStore?.address(for: to.currency)
                let data = EstimateFeeRequestData(amount: to.tokenValue,
                                                  currency: to.currency.code,
                                                  destination: address)
                EstimateFeeWorker().execute(requestData: data) { [weak self] result in
                    switch result {
                    case .success(let fee):
                        self?.dataStore?.toFee = nil
                        self?.dataStore?.ethFee = fee?.fee
                        self?.presenter?.presentAssets(actionResponse: .init(amount: self?.dataStore?.toAmount,
                                                                             card: self?.dataStore?.paymentCard,
                                                                             quote: self?.dataStore?.quote))
                        
                    case .failure(let error):
                        self?.dataStore?.ethFee = nil
                        self?.dataStore?.toFee = nil
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                }
            }
        }
    }
    
    func setAssets(viewAction: BuyModels.Assets.ViewAction) {
        if let value = viewAction.currency?.lowercased(),
           let currency = Store.state.currencies.first(where: { $0.code.lowercased() == value }) {
            dataStore?.toCurrency = currency
            dataStore?.ethFee = nil
            dataStore?.toFee = nil
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
                self?.dataStore?.allPaymentCards = data
                
            default:
                break
            }
            
            completion?(result)
        }
    }
}
