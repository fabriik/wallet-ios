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
        
        fetchCards { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.getExchangeRate(viewAction: .init())
                self.presenter?.presentData(actionResponse: .init(item: Models.Item(amount: .zero(currency), paymentCard: self.dataStore?.paymentCard)))
                self.presenter?.presentAssets(actionResponse: .init(amount: self.dataStore?.toAmount, card: self.dataStore?.paymentCard))
                
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
            getFees()
        } else if let value = viewAction.fiatValue {
            dataStore?.isInputFiat = true
            dataStore?.from = ExchangeFormatter.fiat.number(from: value)?.decimalValue
            dataStore?.to = (dataStore?.from ?? 0) * rate
        }
        
        presenter?.presentAssets(actionResponse: .init(amount: dataStore?.toAmount, card: dataStore?.paymentCard))
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
                self?.presenter?.presentExchangeRate(actionResponse: .init(from: from,
                                                                           to: toCurrency,
                                                                           rate: quote?.exchangeRate,
                                                                           expires: (quote?.timestamp ?? 0) + 600))
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
        
        if to.currency.isEthereumCompatible {
            let address = dataStore?.address(for: to.currency)
            let data = EstimateFeeRequestData(amount: to.tokenValue,
                                              currency: to.currency.code,
                                              destination: address)
            EstimateFeeWorker().execute(requestData: data) { [weak self] result in
                switch result {
                case .success(let fee):
                    self?.dataStore?.toFee = nil
                    self?.dataStore?.ethFee = fee?.fee
                    self?.setAmount(viewAction: .init())
                    
                case .failure(let error):
                    self?.presenter?.presentError(actionResponse: .init(error: error))
                }
            }
        } else {
            let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
            sender.estimateFee(address: address,
                               amount: value,
                               tier: .regular,
                               isStake: false) { [weak self] result in
                switch result {
                case .success(let fee):
                    self?.dataStore?.ethFee = nil
                    self?.dataStore?.toFee = fee
                    self?.setAmount(viewAction: .init())
                    
                case .failure(let error):
                    self?.presenter?.presentError(actionResponse: .init(error: error))
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
        let fiat = dataStore?.from ?? 0
        let profile = UserManager.shared.profile
        let dailyLimit = profile?.buyDailyRemainingLimit ?? 0
        let lifetimeLimit = profile?.buyLifetimeRemainingLimit ?? 0
        let exchangeLimit = profile?.buyAllowancePerPurchase    ?? 0
        let minimumAmount = dataStore?.quote?.minimumValue ?? 0
        let maximumAmount = dataStore?.quote?.maximumValue ?? 0
            
        var hasError = false
        switch fiat {
        case _ where fiat <= 0:
            // fiat value is bellow 0
            presenter?.presentError(actionResponse: .init(error: nil))
            hasError = true
            
        case _ where minimumAmount > maximumAmount:
            presenter?.presentError(actionResponse: .init(error: BuyErrors.notPermitted))
            hasError = true
            
        case _ where fiat < minimumAmount:
            // value bellow minimum fiat
            presenter?.presentError(actionResponse: .init(error: BuyErrors.tooLow(amount: minimumAmount, currency: Store.state.defaultCurrencyCode)))
            hasError = true
            
        case _ where fiat > dailyLimit:
            // over daily limit
            presenter?.presentError(actionResponse: .init(error: BuyErrors.overDailyLimit))
            hasError = true
            
        case _ where fiat > lifetimeLimit:
            // over lifetime limit
            presenter?.presentError(actionResponse: .init(error: BuyErrors.overLifetimeLimit))
            hasError = true
            
        case _ where fiat > exchangeLimit:
            // over exchange limit ???
            presenter?.presentError(actionResponse: .init(error: BuyErrors.overExchangeLimit))
            hasError = true
            
        case _ where fiat > maximumAmount:
            // over exchange limit ???
            presenter?.presentError(actionResponse: .init(error: BuyErrors.tooHigh(amount: fiat, currency: "USD")))
            hasError = true
            
        default:
            // remove error
            presenter?.presentError(actionResponse: .init(error: nil))
        }
        
        guard hasError == false else { return }

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
