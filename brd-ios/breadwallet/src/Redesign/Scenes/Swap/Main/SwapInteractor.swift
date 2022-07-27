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
        
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.dataStore?.supportedCurrencies = currencies
                self?.dataStore?.baseCurrencies = Array(Set(currencies.compactMap({ $0.baseCurrency })))
                self?.dataStore?.termCurrencies = Array(Set(currencies.compactMap({ $0.termCurrency })))
                self?.dataStore?.baseAndTermCurrencies = currencies.compactMap({ [$0.baseCurrency, $0.termCurrency] })
                self?.dataStore?.fromCurrency = self?.dataStore?.currencies.first(where: { $0.code == "BCH" })
                self?.dataStore?.toCurrency = self?.dataStore?.currencies.first(where: { $0.code == "BSV" })
                self?.getQuote(isInitialLaunch: true)
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func updateRate(viewAction: SwapModels.Rate.ViewAction) {
        getQuote(isInitialLaunch: false)
    }
    
    private func getQuote(isInitialLaunch: Bool) {
        guard let quoteTerm = dataStore?.quoteTerm else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "<empty>")))
            handleQuote(nil, isInitialLaunch: isInitialLaunch)
            return
        }
        
        QuoteWorker().execute(requestData: QuoteRequestData(security: quoteTerm)) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.handleQuote(quote, isInitialLaunch: isInitialLaunch)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
                self?.handleQuote(nil, isInitialLaunch: isInitialLaunch)
            }
        }
    }
    
    private func handleQuote(_ quote: Quote?, isInitialLaunch: Bool) {
        if isInitialLaunch {
            presenter?.presentData(actionResponse: .init(item: Models.Item(from: dataStore?.fromCurrency, to: dataStore?.toCurrency, quote: quote)))
        }
        
        guard let baseCurrency = dataStore?.fromCurrency?.coinGeckoId,
              let termCurrency = dataStore?.toCurrency?.coinGeckoId else {
            self.dataStore?.quote = nil
            setAmount(viewAction: .init())
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.quoteTerm)))
            return
        }
        
        dataStore?.quote = quote
        let coinGeckoIds = [baseCurrency, termCurrency]
        let vs = dataStore?.defaultCurrencyCode?.lowercased() ?? ""
        let resource = Resources.simplePrice(ids: coinGeckoIds, vsCurrency: vs, options: [.change]) { [weak self] (result: Result<[SimplePrice], CoinGeckoError>) in
            switch result {
            case .success(let data):
                self?.dataStore?.fromRate = Decimal(data.first(where: { $0.id == baseCurrency })?.price ?? 0)
                self?.dataStore?.toRate = Decimal(data.first(where: { $0.id == termCurrency })?.price ?? 0)
                
                self?.presenter?.presentUpdateRate(actionResponse: .init(quote: self?.dataStore?.quote,
                                                                         from: self?.dataStore?.fromCurrency,
                                                                         to: self?.dataStore?.toCurrency,
                                                                         fromRate: self?.dataStore?.fromRate,
                                                                         toRate: self?.dataStore?.toRate))
                self?.setAmount(viewAction: .init())
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
        CoinGeckoClient().load(resource)
    }
    
    private func estimateFee(amount: Decimal?, currencyCode: String?, completion: @escaping ((Result<TransferFeeBasis, Error>) -> Void)) {
            guard let amount = amount,
              amount > 0,
              amount.isNaN == false,
              let currency = dataStore?.currencies.first(where: { $0.code == currencyCode }),
              let wallet = dataStore?.coreSystem?.wallet(for: currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore?.keyStore
        else {
            completion(.failure(SwapErrors.general))
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        
        var addressScheme: AddressScheme
        if currency.isBitcoin {
            addressScheme = UserDefaults.hasOptedInSegwit ? .btcSegwit : .btcLegacy
        } else {
            addressScheme = currency.network.defaultAddressScheme
        }
        
        let address = currency.wallet?.receiveAddress(for: addressScheme) ?? ""
        
        sender.estimateFee(address: address,
                           amount: .init(tokenString: String(describing: amount.doubleValue), currency: currency),
                           tier: .regular,
                           isStake: false,
                           completion: { result in
            switch result {
            case .success(let fee):
                let amount = Amount(cryptoAmount: fee.fee, currency: currency)
                print("\(amount.tokenValue)")
                completion(.success(fee))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func getBaseCurrencyImage() -> UIImage? {
        guard let baseCurrency = dataStore?.fromCurrency else { return nil }
        
        return baseCurrency.imageSquareBackground
    }
    
    private func getTermCurrencyImage() -> UIImage? {
        guard let termCurrency = dataStore?.toCurrency else { return nil }
        
        return termCurrency.imageSquareBackground
    }
    
    private func getBaseBalance() -> Amount? {
        guard let baseCurrency = dataStore?.fromCurrency,
              let baseBalance = baseCurrency.state?.balance else { return nil }
        
        return baseBalance
    }
    
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction) {
        let from = dataStore?.fromCurrency
        dataStore?.fromCurrency = dataStore?.toCurrency
        dataStore?.toCurrency = from
        
        dataStore?.minMaxToggleValue = nil
        dataStore?.quote = nil
        dataStore?.from = nil
        dataStore?.to = nil
        dataStore?.fromFee = nil
        dataStore?.toFee = nil
        
        presenter?.presentUpdateRate(actionResponse: .init(quote: dataStore?.quote,
                                                           from: dataStore?.fromCurrency,
                                                           to: dataStore?.toCurrency))
        setAmount(viewAction: .init())
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        var viewAction = viewAction
        
        if let minMaxToggleValue = viewAction.minMaxToggleValue {
            dataStore?.minMaxToggleValue = minMaxToggleValue
            
            let minAmount: Decimal = 50 // TODO: Constant
            
            switch minMaxToggleValue {
            case .min:
                viewAction.fromFiatAmount = String(describing: minAmount)
                
            case .max:
                viewAction.fromCryptoAmount = "\(getBaseBalance()?.tokenValue ?? 0)"
            }
        }
        
        let group = DispatchGroup()
        group.enter()
        
        let from = dataStore?.from?.tokenValue == 0 ? NSDecimalNumber(string: viewAction.fromCryptoAmount ?? "0").decimalValue : dataStore?.from?.tokenValue
        estimateFee(amount: from, currencyCode: dataStore?.fromCurrency?.code) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.fromFee = fee
                
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        
        let to = dataStore?.to?.tokenValue == 0 ? NSDecimalNumber(string: viewAction.toCryptoAmount ?? "0").decimalValue : dataStore?.to?.tokenValue
        estimateFee(amount: to, currencyCode: dataStore?.toCurrency?.code) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.toFee = fee
                
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [unowned self] in
            calculateAmounts(viewAction: viewAction)
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
        
        dataStore?.from = nil
        dataStore?.to = nil
        dataStore?.fromFee = nil
        dataStore?.toFee = nil
        dataStore?.minMaxToggleValue = nil
        
        getQuote(isInitialLaunch: false)
    }
    
    func selectAsset(viewAction: SwapModels.Assets.ViewAction) {
        var from: [String]?
        var to: [String]?
        
        if viewAction.to == true {
            to = dataStore?.supportedCurrencies?.compactMap { item in
                guard item.baseCurrency == dataStore?.fromCurrency?.code else {
                    return nil
                }
                return item.termCurrency
            }
        } else {
            from = dataStore?.baseCurrencies
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
        
        guard viewAction.authenticated == true else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.pinConfirmation))
            return
        }
        guard let currency = dataStore?.currencies.first(where: { $0.code == dataStore?.toCurrency?.code }),
              let address = dataStore?.coreSystem?.wallet(for: currency)?.receiveAddress
        else {
            return
        }
        
        let data = SwapRequestData(quoteId: dataStore?.quote?.quoteId,
                                   quantity: dataStore?.from?.tokenValue ?? 0,
                                   destination: address,
                                   side: dataStore?.side.rawValue)
        
        SwapWorker().execute(requestData: data) { [weak self] result in
            switch result {
            case .success(let data):
                self?.dataStore?.swap = data
                self?.createTransaction(destination: data.address)
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    private func createTransaction(destination: String?) {
        guard let currency = dataStore?.fromCurrency,
              let wallet = dataStore?.coreSystem?.wallet(for: currency),
              let kvStore = Backend.kvStore, let keyStore = dataStore?.keyStore else {
            // TODO: handle error
            return
        }
        
        guard let destination = destination,
              let fromAmount = dataStore?.to?.tokenValue.doubleValue,
              let fee = dataStore?.fromFee,
              let pair = dataStore?.quoteTerm
        else {
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)

        let amount = Amount(tokenString: "\(fromAmount)", currency: currency)
        let result = sender.createTransaction(address: destination,
                                              amount: amount,
                                              feeBasis: fee,
                                              comment: "Swapping \(pair)",
                                              exchangeId: dataStore?.swap?.exchangeId)
        
        switch result {
        case .ok:
            let from = dataStore?.fromCurrency?.code
            let to = dataStore?.toCurrency?.code
            let exchangeId = dataStore?.swap?.exchangeId
            presenter?.presentConfirm(actionResponse: .init(from: from,
                                                            to: to,
                                                            exchangeId: exchangeId))
            
        default:
            // failed
            print("eror")
        }
    }
    
    // MARK: - Aditional helpers
    
    private func calculateAmounts(viewAction: Models.Amounts.ViewAction) {
        guard let fromCurrency = dataStore?.fromCurrency,
              let toCurrency = dataStore?.toCurrency,
              let quote = dataStore?.quote
        else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.quoteTerm)))
            return
        }
        
        let from: Decimal
        let to: Decimal
        if let fromCryptoAmount = viewAction.fromCryptoAmount {
            let fromPrice = quote.closeAsk
            
            from = NSDecimalNumber(string: fromCryptoAmount).decimalValue
            to = (from - (dataStore?.fromFeeAmount?.tokenValue ?? 0)) * fromPrice - (dataStore?.toFeeAmount?.tokenValue ?? 0)
        } else if let fromFiatAmount = viewAction.fromFiatAmount {
            let fromPrice = quote.closeAsk
            
            let fromFiat = NSDecimalNumber(string: fromFiatAmount).decimalValue
            from = fromFiat / (dataStore?.fromRate ?? 0)
            to = (from - (dataStore?.fromFeeAmount?.tokenValue ?? 0)) * fromPrice - (dataStore?.fromFeeAmount?.tokenValue ?? 0)
        } else if let toCryptoAmount = viewAction.toCryptoAmount {
            let fromPrice = quote.closeBid
            
            to = NSDecimalNumber(string: toCryptoAmount).decimalValue
            from = (to + (dataStore?.toFeeAmount?.tokenValue ?? 0)) / fromPrice + (dataStore?.fromFeeAmount?.tokenValue ?? 0)
        } else if let toFiatAmount = viewAction.toFiatAmount {
            let fromPrice = quote.closeBid
            
            let toFiat = NSDecimalNumber(string: toFiatAmount).decimalValue
            to = (toFiat - (dataStore?.toFeeAmount?.fiatValue ?? 0)) / (dataStore?.toRate ?? 0)
            from = (to + (dataStore?.toFeeAmount?.tokenValue ?? 0)) / fromPrice + (dataStore?.fromFeeAmount?.tokenValue ?? 0)
        } else {
            guard dataStore?.fromCurrency != nil,
                  dataStore?.toCurrency != nil
            else { return }
            
            let fromPrice = quote.closeAsk
            if let value = dataStore?.from?.tokenValue {
                from = value
            } else {
                from = 0
            }
            to = (from - (dataStore?.fromFeeAmount?.tokenValue ?? 0)) * fromPrice - (dataStore?.toFeeAmount?.tokenValue ?? 0)
        }
        
        let formatter = NumberFormatter()
        // WalletKits createCryptoAmount func only accepts 8 decimal spaces, else returns 0
        formatter.maximumFractionDigits = 8
        guard let dataStore = dataStore,
              let fromString = formatter.string(for: from),
              let toString = formatter.string(for: to) else {
            // TODO: handle what kind of error?
            return
        }
        
        dataStore.from = Amount(tokenString: fromString, currency: fromCurrency)
        dataStore.to = Amount(tokenString: toString, currency: toCurrency)
        
        presenter?.presentSetAmount(actionResponse: .init(from: dataStore.from,
                                                          to: dataStore.to,
                                                          fromFee: dataStore.fromFeeAmount,
                                                          toFee: dataStore.toFeeAmount,
                                                          minMaxToggleValue: dataStore.minMaxToggleValue,
                                                          baseBalance: getBaseBalance()))
    }
}
