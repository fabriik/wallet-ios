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
        
        TransferManager.shared.reload()
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                guard let currencies = currencies,
                      currencies.count >= 2 else {
                    self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.selectAssets))
                    return
                }
                
                let enabled = self?.dataStore?.currencies.filter { cur in currencies.map { $0.name }.contains(cur.code) }
                
                guard let from = enabled?.first,
                      let to = enabled?.first(where: { $0.code != from.code })
                else {
                    self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.selectAssets))
                    return
                }
                self?.dataStore?.from = .zero(from)
                self?.dataStore?.to = .zero(to)
                
                let item = Models.Item(from: self?.dataStore?.from,
                                       to: self?.dataStore?.to,
                                       quote: self?.dataStore?.quote,
                                       isKYCLevelTwo: self?.dataStore?.isKYCLevelTwo)
                self?.presenter?.presentData(actionResponse: .init(item: item))
                self?.getRate(viewAction: .init())
                
            case .failure:
                self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.selectAssets))
            }
        }
    }
    
    func getRate(viewAction: SwapModels.Rate.ViewAction) {
        guard let from = dataStore?.from?.currency,
              let to = dataStore?.to?.currency else {
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
        
        guard let baseCurrency = from.coinGeckoId,
              let termCurrency = to.coinGeckoId else {
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
        let from = dataStore?.from
        dataStore?.from = dataStore?.to
        dataStore?.to = from
        
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        
        getRate(viewAction: .init())
        getFees(viewAction: .init())
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        guard let fromCurrency = dataStore?.from?.currency,
              let toCurrency = dataStore?.to?.currency
        else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: "No selected currencies."))) // TODO: Localize.
            return
        }
        
        let exchangeRate = dataStore?.quote?.exchangeRate ?? 1
        
        let toFeeRate = dataStore?.quote?.toFeeRate ?? 1
        let toFee = (dataStore?.quote?.toFee?.fee ?? 0) / toFeeRate
        
        let fromRate = dataStore?.fromRate ?? 0
        let toRate = dataStore?.toRate ?? 0
        
        let from: Amount
        let to: Amount
        if let fromCryptoAmount = viewAction.fromCryptoAmount,
           let fromCrypto = ExchangeFormatter.crypto.number(from: fromCryptoAmount)?.decimalValue {
            from = .init(amount: fromCrypto, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(amount: fromCrypto * exchangeRate - toFee, currency: toCurrency, exchangeRate: toRate)
            
        } else if let fromFiatAmount = viewAction.fromFiatAmount,
                  let fromFiat = ExchangeFormatter.fiat.number(from: fromFiatAmount)?.decimalValue {
            from = .init(amount: fromFiat, isFiat: true, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(amount: from.tokenValue * exchangeRate - toFee, currency: toCurrency, exchangeRate: toRate)
            
        } else if let toCryptoAmount = viewAction.toCryptoAmount,
                  let toCrypto = ExchangeFormatter.crypto.number(from: toCryptoAmount)?.decimalValue {
            from = .init(amount: (toCrypto + toFee * toFeeRate) / exchangeRate, currency: fromCurrency, exchangeRate: fromRate)
            to = .init(amount: toCrypto, currency: toCurrency, exchangeRate: toRate)
            
        } else if let toFiatAmount = viewAction.toFiatAmount,
                  let toFiat = ExchangeFormatter.fiat.number(from: toFiatAmount)?.decimalValue {
            to = .init(amount: toFiat, isFiat: true, currency: toCurrency, exchangeRate: toRate)
            from = .init(amount: (to.tokenValue + toFee) / exchangeRate, currency: fromCurrency, exchangeRate: fromRate)
            
        } else {
            presenter?.presentAmount(actionResponse: .init(from: dataStore?.from,
                                                           to: dataStore?.to,
                                                           fromFee: dataStore?.fromFeeAmount,
                                                           toFee: dataStore?.toFeeAmount,
                                                           baseBalance: dataStore?.from?.currency.state?.balance,
                                                           minimumAmount: dataStore?.quote?.minimumUsd,
                                                           handleErrors: viewAction.handleErrors))
            return
        }
        
        dataStore?.from = from
        dataStore?.to = to
        
        presenter?.presentAmount(actionResponse: .init(from: dataStore?.from,
                                                       to: dataStore?.to,
                                                       fromFee: dataStore?.fromFeeAmount,
                                                       toFee: dataStore?.toFeeAmount,
                                                       baseBalance: dataStore?.from?.currency.state?.balance,
                                                       minimumAmount: dataStore?.quote?.minimumUsd,
                                                       handleErrors: viewAction.handleErrors))
    }
    
    func getFees(viewAction: Models.Fee.ViewAction) {
        guard let from = dataStore?.from,
              let fromAddress = from.currency.wallet?.defaultReceiveAddress
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        // fetching new fees
        fetchWkFee(for: from,
                   address: fromAddress,
                   wallet: dataStore?.coreSystem?.wallet(for: from.currency),
                   keyStore: dataStore?.keyStore,
                   kvStore: Backend.kvStore) { [weak self] fee in
            self?.dataStore?.fromFee = fee
            
            guard self?.dataStore?.fromFee != nil else {
                self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
                return
            }
            
            self?.setAmount(viewAction: .init(handleErrors: true))
        }
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        if let asset = viewAction.from,
           let currency = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.from = .zero(currency)
            getFees(viewAction: .init())
        }
        
        if let asset = viewAction.to,
           let currency = dataStore?.currencies.first(where: { $0.code == asset }) {
            dataStore?.to = .zero(currency)
        }
        
        dataStore?.quote = nil
        dataStore?.fromRate = nil
        dataStore?.toRate = nil
        dataStore?.fromFee = nil
        
        setAmount(viewAction: .init())
        getRate(viewAction: .init())
        
        // TODO: hide error if pressent
        presenter?.presentError(actionResponse: .init())
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
        
        guard let currency = dataStore?.currencies.first(where: { $0.code == dataStore?.to?.currency.code }),
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
    
    func showAssetInfoPopup(viewAction: SwapModels.AssetInfoPopup.ViewAction) {
        presenter?.presentAssetInfoPopup(actionResponse: .init())
    }
    
    // MARK: - Aditional helpers
    
    private func createTransaction(from swap: Swap?) {
        guard let dataStore = dataStore,
              let currency = dataStore.currencies.first(where: { $0.code == swap?.currency }),
              let wallet = dataStore.coreSystem?.wallet(for: currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore.keyStore else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        guard let destination = swap?.address,
              let amountValue = swap?.amount,
              let fee = dataStore.fromFee,
              let exchangeId = dataStore.swap?.exchangeId
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noFees))
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        let amount = Amount(amount: amountValue, currency: currency)
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
                    TransferManager.shared.reload()
                    
                    let from = self?.dataStore?.from?.currency.code
                    let to = self?.dataStore?.to?.currency.code
                    
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
