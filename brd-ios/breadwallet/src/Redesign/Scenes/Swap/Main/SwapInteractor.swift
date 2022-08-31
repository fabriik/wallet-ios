//
//  SwapInteractor.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit
import WalletKit

class SwapInteractor: NSObject, Interactor, SwapViewActions {
    
    typealias Models = SwapModels
    
    var presenter: SwapPresenter?
    var dataStore: SwapStore?
    
    // MARK: - SwapViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard dataStore?.currencies.isEmpty == false else { return }
        
        ExchangeManager.shared.reload()
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                guard let currencies = currencies,
                      currencies.count >= 2 else { return }
                
                let first = currencies[0]
                let second = currencies[1]
                
                self?.dataStore?.supportedCurrencies = currencies
                self?.dataStore?.fromCurrency = self?.dataStore?.currencies.first(where: { $0.code == first.name })
                self?.dataStore?.toCurrency = self?.dataStore?.currencies.first(where: { $0.code == second.name })
                
                let item = Models.Item(from: self?.dataStore?.fromCurrency,
                                       to: self?.dataStore?.toCurrency,
                                       quote: self?.dataStore?.quote,
                                       isKYCLevelTwo: self?.dataStore?.isKYCLevelTwo)
                self?.presenter?.presentData(actionResponse: .init(item: item))
                self?.getRate(viewAction: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func getRate(viewAction: SwapModels.Rate.ViewAction) {
        guard let from = dataStore?.fromCurrency,
              let to = dataStore?.toCurrency else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.swapPair ?? "")))
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        QuoteWorker().execute(requestData: QuoteRequestData(from: from.code, to: to.code)) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.dataStore?.quote = quote
                self?.presenter?.presentRate(actionResponse: .init(quote: quote,
                                                                   from: from,
                                                                   to: to))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
            group.leave()
        }
        
        guard let from = dataStore?.fromCurrency,
              let baseCurrency = from.coinGeckoId,
              let termCurrency = dataStore?.toCurrency?.coinGeckoId else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.swapPair)))
            return
        }
        
        group.enter()
        let coinGeckoIds = [baseCurrency, termCurrency]
        let vs = dataStore?.defaultCurrencyCode ?? ""
        let resource = Resources.simplePrice(ids: coinGeckoIds, vsCurrency: vs, options: [.change]) { [weak self] (result: Result<[SimplePrice], CoinGeckoError>) in
            switch result {
            case .success(let data):
                self?.dataStore?.fromRate = Decimal(data.first(where: { $0.id == baseCurrency })?.price ?? 0)
                self?.dataStore?.toRate = Decimal(data.first(where: { $0.id == termCurrency })?.price ?? 0)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
            group.leave()
        }
        
        CoinGeckoClient().load(resource)
        
        group.notify(queue: .main) { [weak self] in
            self?.setAmount(viewAction: .init())
        }
    }
    
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction) {
        let from = dataStore?.fromCurrency
        dataStore?.fromCurrency = dataStore?.toCurrency
        dataStore?.toCurrency = from
        
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        dataStore?.toFee = nil
        dataStore?.fromFeeEth = nil
        dataStore?.toFeeEth = nil
        
        setAmount(viewAction: .init())
        getRate(viewAction: .init())
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        recalculate(viewAction: viewAction)
        getFees(viewAction: .init(from: dataStore?.from, to: dataStore?.to))
    }
    
    private func recalculate(viewAction: SwapModels.Amounts.ViewAction) {
        guard let dataStore = dataStore,
              let fromCurrency = dataStore.fromCurrency,
              let toCurrency = dataStore.toCurrency
        else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: "No selected currencies.")))
            return
        }
        
        let exchangeRate = dataStore.quote?.exchangeRate ?? 1
        let markup = dataStore.quote?.markup ?? 1
        
        let toFeeRate = dataStore.quote?.toFeeCurrency?.rate ?? 1
        let toFee = (dataStore.toFeeAmount?.tokenValue ?? 0) / toFeeRate
        
        let fromRate = dataStore.fromRate ?? 0
        let toRate = dataStore.toRate ?? 0
        
        let from: Decimal
        let to: Decimal
        if let fromCryptoAmount = viewAction.fromCryptoAmount,
           let fromCrypto = ExchangeFormatter.crypto.number(from: fromCryptoAmount)?.decimalValue {
            
            from = fromCrypto
            to = fromCrypto * exchangeRate / markup - toFee
            
        } else if let fromFiatAmount = viewAction.fromFiatAmount,
                  let fromFiat = ExchangeFormatter.fiat.number(from: fromFiatAmount)?.decimalValue {
            
            from = fromFiat / fromRate
            to = from * exchangeRate / markup - toFee
            
        } else if let toCryptoAmount = viewAction.toCryptoAmount,
                  let toCrypto = ExchangeFormatter.crypto.number(from: toCryptoAmount)?.decimalValue {
            
            from = (toCrypto + toFee * toFeeRate) / exchangeRate * markup
            to = toCrypto
            
        } else if let toFiatAmount = viewAction.toFiatAmount,
                  let toFiat = ExchangeFormatter.fiat.number(from: toFiatAmount)?.decimalValue {
            
            to = toFiat / toRate
            from = (to + toFee) / exchangeRate * markup
            
        } else {
            guard dataStore.fromCurrency != nil,
                  dataStore.toCurrency != nil else { return }
            
            from = dataStore.from?.tokenValue ?? 0
            to =  from * exchangeRate / markup - toFee   
        }
        
        dataStore.from = dataStore.amountFrom(decimal: from, currency: fromCurrency)
        dataStore.to = dataStore.amountFrom(decimal: to, currency: toCurrency)
    }
    
    func getFees(viewAction: Models.Fee.ViewAction) {
        guard let from = viewAction.from,
              let to = viewAction.to
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        let group = DispatchGroup()
        group.enter()
        
        guard let dataStore = dataStore,
              let wallet = dataStore.coreSystem?.wallet(for: from.currency),
              let kvStore = Backend.kvStore,
              let keyStore = dataStore.keyStore,
              let address = dataStore.address(for: from.currency)
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        var value = dataStore.amountFrom(decimal: from.tokenValue, currency: from.currency)
        var sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        sender.estimateFee(address: address,
                           amount: value,
                           tier: .regular,
                           isStake: false) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.fromFee = fee
                group.leave()
                
            case .failure(let error):
                guard from.currency.isEthereumCompatible == true else {
                    self?.presenter?.presentError(actionResponse: .init(error: error))
                    group.leave()
                    return
                }
                
                let address = self?.dataStore?.address(for: from.currency)
                let data = EstimateFeeRequestData(amount: from.tokenValue,
                                                  currency: from.currency.code,
                                                  destination: address)
                
                EstimateFeeWorker().execute(requestData: data) { [weak self] result in
                    switch result {
                    case .success(let fee):
                        self?.dataStore?.fromFeeEth = fee?.fee
                        
                    case .failure(let error):
                        self?.presenter?.presentError(actionResponse: .init(error: error))
                    }
                    group.leave()
                }
            }
        }
        
        guard let wallet = dataStore.coreSystem?.wallet(for: to.currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore.keyStore,
              let address = dataStore.address(for: to.currency)
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        group.enter()
        value = dataStore.amountFrom(decimal: to.tokenValue, currency: to.currency)
        sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        sender.estimateFee(address: address,
                           amount: value,
                           tier: .regular,
                           isStake: false) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.toFee = fee
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.recalculate(viewAction: .init())
            
            self?.presenter?.presentAmount(actionResponse: .init(from: dataStore.from,
                                                                 to: dataStore.to,
                                                                 fromFee: dataStore.fromFeeAmount,
                                                                 toFee: dataStore.toFeeAmount,
                                                                 baseBalance: dataStore.from?.currency.state?.balance,
                                                                 minimumAmount: dataStore.quote?.minimumUsd
                                                                ))
        }
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        if let asset = viewAction.from,
           let currency = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.fromCurrency = currency
        }
        
        if let asset = viewAction.to,
           let currency = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.toCurrency = currency
        }
    
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        dataStore?.toFee = nil
        dataStore?.fromFeeEth = nil
        dataStore?.toFeeEth = nil
        
        setAmount(viewAction: .init())
        getRate(viewAction: .init())
    }
    
    func selectAsset(viewAction: SwapModels.Assets.ViewAction) {
        var from: [Currency]?
        var to: [Currency]?
        
        if viewAction.to == true {
            to = dataStore?.currencies.filter { $0.code != dataStore?.from?.currency.code }
        } else {
            from = dataStore?.currencies.filter { $0.code != dataStore?.to?.currency.code }
        }
        
        presenter?.presentSelectAsset(actionResponse: .init(from: from, to: to))
    }
    
    func showConfirmation(viewAction: SwapModels.ShowConfirmDialog.ViewAction) {
        presenter?.presentConfirmation(actionResponse: .init(from: dataStore?.from,
                                                             to: dataStore?.to,
                                                             quote: dataStore?.quote,
                                                             fromFee: dataStore?.fromFeeAmount,
                                                             toFee: dataStore?.toFeeAmount))
    }
    
    func confirm(viewAction: SwapModels.Confirm.ViewAction) {
        dataStore?.pin = viewAction.pin
        
        guard let currency = dataStore?.currencies.first(where: { $0.code == dataStore?.toCurrency?.code }),
              let address = dataStore?.coreSystem?.wallet(for: currency)?.receiveAddress,
              let from = dataStore?.from?.tokenValue,
              let to = dataStore?.to?.tokenValue
        else {
            return
        }
        
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   depositQuantity: from,
                                   withdrawalQuantity: to,
                                   destination: address)
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.swap = data
                self?.createTransaction(from: data)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.failed(error: error)))
            }
        }
    }
    
    func showInfoPopup(viewAction: SwapModels.InfoPopup.ViewAction) {
        presenter?.presentInfoPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func createTransaction(from swap: Swap?) {
        guard let dataStore = dataStore,
              let currency = dataStore.currencies.first(where: { $0.code == swap?.currency }),
              let wallet = dataStore.coreSystem?.wallet(for: currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore.keyStore else {
            // TODO: handle error
            return
        }
        
        guard let destination = swap?.address,
              let amountValue = swap?.amount,
              let fee = dataStore.fromFee,
              let exchangeId = dataStore.swap?.exchangeId
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.notEnouthEthForFee(fee: dataStore.fromFeeEth ?? 0)))
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        let amount = dataStore.amountFrom(decimal: amountValue, currency: currency)
        let result = sender.createTransaction(address: destination,
                                              amount: amount,
                                              feeBasis: fee,
                                              comment: nil,
                                              exchangeId: exchangeId)
        
        var error: FEError?
        switch result {
        case .ok:
            sender.sendTransaction(allowBiometrics: true, exchangeId: exchangeId) { [weak self] data in
                guard let pin = self?.dataStore?.pin else {
                    self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.pinConfirmation))
                    return
                }
                data(pin)
            } completion: { [weak self] result in
                var error: FEError?
                switch result {
                case .success:
                    ExchangeManager.shared.reload()
                    
                    let from = self?.dataStore?.fromCurrency?.code
                    let to = self?.dataStore?.toCurrency?.code
                    
                    self?.presenter?.presentConfirm(actionResponse: .init(from: from, to: to, exchangeId: exchangeId))
                    
                case .creationError(let message):
                    error = GeneralError(errorMessage: message)
                    
                case .insufficientGas:
                    error = SwapErrors.networkFee
                    
                case .publishFailure(let code, let message):
                    error = GeneralError(errorMessage: "Error \(code): \(message)")
                }
                
                guard let error = error else { return }
                self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.failed(error: error)))
            }
            
        case .failed:
            error = GeneralError(errorMessage: "Unknown error")
            
        case .invalidAddress:
            error = GeneralError(errorMessage: "invalid address")
            
        case .ownAddress:
            error = GeneralError(errorMessage: "Own address")
            
        case .insufficientFunds:
            error = SwapErrors.balanceTooLow(balance: currency.state?.balance?.tokenValue ?? 0, currency: currency.code)
            
        case .noExchangeRate:
            error = SwapErrors.noQuote(pair: dataStore.swapPair)
            
        case .noFees:
            error = SwapErrors.noFees
            
        case .outputTooSmall(let amount):
            error = SwapErrors.tooLow(amount: amount.tokenValue, currency: amount.currency.code)
            
        case .invalidRequest(let string):
            error = GeneralError(errorMessage: string)
            
        case .paymentTooSmall(let amount):
            error = SwapErrors.tooLow(amount: amount.tokenValue, currency: amount.currency.code)
            
        case .usedAddress:
            error = GeneralError(errorMessage: "Used address")
            
        case .identityNotCertified(let string):
            error = GeneralError(errorMessage: "Not certified \(string)")
            
        case .insufficientGas:
            error = SwapErrors.networkFee
        }
        
        guard let error = error else { return }
        presenter?.presentError(actionResponse: .init(error: error))
    }
}
