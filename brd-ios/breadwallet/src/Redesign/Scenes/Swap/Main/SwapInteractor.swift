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
                self?.dataStore?.fromCurrency = self?.dataStore?.currencies.first(where: { $0.code == "BSV" })
                self?.dataStore?.toCurrency = self?.dataStore?.currencies.first(where: { $0.code == "BTC" })
                self?.getQuote(isInitialLaunch: true)
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
    }
    
    func updateRate(viewAction: SwapModels.Rate.ViewAction) {
        getQuote(isInitialLaunch: false)
    }
    
    private func getQuote(isInitialLaunch: Bool = false) {
        guard let quoteTerm = dataStore?.quoteTerm else {
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: "<empty>")))
            handleQuote(nil, isInitialLaunch: isInitialLaunch)
            return
        }
        
        QuoteWorker().execute(requestData: QuoteRequestData(security: quoteTerm)) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.handleQuote(quote, isInitialLaunch: isInitialLaunch)
                
            case .failure:
                self?.presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: quoteTerm)))
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
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.quoteTerm)))
            setAmount(viewAction: .init())
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
                           amount: .init(tokenString: amount.doubleValue.description, currency: currency),
                           tier: .regular,
                           isStake: false,
                           completion: { [weak self] result in
            switch result {
            case .success(let fee):
                guard let currency = self?.dataStore?.currencies.first(where: { $0.code == fee.currency.code.uppercased() }) else {
                    let error = SwapErrors.general
                    completion(.failure(error))
                    return
                }
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
        
        getQuote(isInitialLaunch: true)
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
                viewAction.fromCryptoAmount = "\(dataStore?.fromCurrency?.state?.balance?.tokenValue ?? 0)"
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
        
        group.notify(queue: .main) { [weak self] in
            self?.calculateAmounts(viewAction: viewAction)
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
        dataStore?.pin = viewAction.pin
        
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
              let fromAmount = formatAmount(amount: dataStore?.from?.tokenValue, for: currency),
              let fee = dataStore?.fromFee,
              let pair = dataStore?.quoteTerm,
              let exchangeId = dataStore?.swap?.exchangeId
        else {
            return
        }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)

        let amount = Amount(tokenString: fromAmount, currency: currency)
        let result = sender.createTransaction(address: destination,
                                              amount: amount,
                                              feeBasis: fee,
                                              comment: "Swapping \(pair)",
                                              exchangeId: exchangeId)
        
        let from = dataStore?.fromCurrency?.code
        let to = dataStore?.toCurrency?.code
        
        var error: FEError?
        switch result {
        case .ok:
            // TODO: uncomment this once BE is fixed
            let error = GeneralError(errorMessage: "Due to backend issues swapping is currencly disabled. Please try again later")
            presenter?.presentError(actionResponse: .init(error: error))
            
            return ()
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
                    self?.presenter?.presentConfirm(actionResponse: .init(from: from, to: to, exchangeId: exchangeId))

                case .creationError(let message):
                    error = GeneralError(errorMessage: message)

                case .insufficientGas:
                    error = SwapErrors.networkFee

                case .publishFailure(let code, let message):
                    error = GeneralError(errorMessage: "Error \(code): \(message)")
                }

                guard let error = error else { return }
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
            
        case .failed:
            error = GeneralError(errorMessage: "Unknown error")
            
        case .invalidAddress:
            error = GeneralError(errorMessage: "invalid address")
            
        case .ownAddress:
            error = GeneralError(errorMessage: "Own address")
            
        case .insufficientFunds:
            error = SwapErrors.balanceTooLow(amount: amount.tokenValue, balance: currency.state?.balance?.tokenValue ?? 0, currency: currency.code)
            
        case .noExchangeRate:
            error = SwapErrors.noQuote(pair: dataStore?.quoteTerm ?? "")
            
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
    
    // MARK: - Aditional helpers
    
    private func calculateAmounts(viewAction: Models.Amounts.ViewAction) {
        guard let fromCurrency = dataStore?.fromCurrency,
              let toCurrency = dataStore?.toCurrency
        else {
            presenter?.presentError(actionResponse: .init(error: GeneralError(errorMessage: "No selected currencies.")))
            return
        }
        
        guard let quote = dataStore?.quote else {
                presenter?.presentSetAmount(actionResponse: .init(from: .zero(fromCurrency),
                                                                  to: .zero(toCurrency),
                                                                  fromFee: .zero(fromCurrency),
                                                                  toFee: .zero(toCurrency),
                                                                  baseBalance: fromCurrency.state?.balance,
                                                                  minimumAmount: 0))
            presenter?.presentError(actionResponse: .init(error: SwapErrors.noQuote(pair: dataStore?.quoteTerm)))
            return
        }
        // TODO: update calculations to include markups!
        let fromFee = dataStore?.fromFeeAmount?.tokenValue ?? 0
        let toFee = dataStore?.toFeeAmount?.tokenValue ?? 0
        
        let fromRate = dataStore?.fromRate ?? 0
        let toRate = dataStore?.toRate ?? 0
        
        let from: Decimal
        let to: Decimal
        if let fromCryptoAmount = viewAction.fromCryptoAmount {
            let price = quote.exchangeRate
            from = NSDecimalNumber(string: fromCryptoAmount).decimalValue
            to = (from - fromFee) * price - toFee
            
        } else if let fromFiatAmount = viewAction.fromFiatAmount {
            let price = quote.exchangeRate
            let fromFiat = NSDecimalNumber(string: fromFiatAmount).decimalValue
            from = fromFiat / fromRate
            to = (from - fromFee) * price - fromFee
            
        } else if let toCryptoAmount = viewAction.toCryptoAmount {
            let price = quote.exchangeRate
            to = NSDecimalNumber(string: toCryptoAmount).decimalValue
            from = (to + toFee) / price + fromFee
            
        } else if let toFiatAmount = viewAction.toFiatAmount {
            let price = quote.exchangeRate
            let toFiat = NSDecimalNumber(string: toFiatAmount).decimalValue
            to = (toFiat - toFee) / toRate
            from = (to + toFee) / price + fromFee
            
        } else {
            guard dataStore?.fromCurrency != nil,
                  dataStore?.toCurrency != nil
            else { return }
            
            let price = quote.exchangeRate
            if let value = dataStore?.from?.tokenValue {
                from = value
            } else {
                from = 0
            }
            to = (from - (dataStore?.fromFeeAmount?.tokenValue ?? 0)) * price - (dataStore?.toFeeAmount?.tokenValue ?? 0)
        }
        
        guard let dataStore = dataStore,
              let fromString = formatAmount(amount: from, for: fromCurrency),
              let toString = formatAmount(amount: to, for: toCurrency)
        else {
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
                                                          baseBalance: fromCurrency.state?.balance,
                                                          minimumAmount: dataStore.quote?.minUsdAmount))
    }
    
    private func formatAmount(amount: Decimal?, for currency: Currency?) -> String? {
        guard let amount = amount,
              let currency = currency
        else {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5 //Int(currency.baseUnit.decimals)
        
        return formatter.string(for: amount)
        
    }
}
