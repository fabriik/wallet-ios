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

enum SwapErrors: Error {
    case noQuote
    case general
    case tooLow
    case tooHigh
    case balanceTooLow
    case overDailyLimit
    case overLifetimeLimit
    case networkFee
    
    var errorMessage: String {
        switch self {
            /// Param 1&2 -> currency, param 3 balance
        case .balanceTooLow:
            return "You don't have enough %@ to complete this swap. Your current %@ balance is %@"
            
        case .general:
            return "BSV network is experiencing network issues. Swapping assets is temporarily unavailable."
            
            /// Param 1: amount, param 2 currency symbol
        case .tooLow:
            return "The amount is lower than the swap minimum of %.10f, %@"
            
        case .tooHigh:
            /// Param 1: amount, param 2 currency symbol
            return "The amount is higher than the swap maximum of %.5f %@"
            
        case .overDailyLimit:
            return "You have reached your swap limit of 1,000 USD a day. Please upgrade your limits or change the amount for this swap."
            
        case .overLifetimeLimit:
            return "You have reached your lifetime swap limit of 10,000 USD. Please upgrade your limits or change the amount for this swap."
            
        case .networkFee:
            return "This swap doesn't cover the included network fee. Please add more funds to your wallet or change the amount you're swapping"
            // TODO: unoficial error xD
        case .noQuote:
            return "No quote for currency pair."
        }
    }
}

class SwapInteractor: NSObject, Interactor, SwapViewActions {
    
    typealias Models = SwapModels
    
    var presenter: SwapPresenter?
    var dataStore: SwapStore?
    
    // TODO: datastore? or CryptoRateCalculatorManager smth? :D
    private var quote: Quote?
    private var bidCryptoRate: Decimal = 0
    private var normalFiatRate: Decimal = 0
    
    private var askCryptoRate: Decimal = 0
    private var switchedFiatRate: Decimal = 0
    
    private var quoteTimeStamp: Double = 0
    
    private var lastError: Error?
    
    // MARK: - SwapViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.dataStore?.supportedCurrencies = currencies
                self?.dataStore?.baseCurrencies = Array(Set(currencies.compactMap({ $0.baseCurrency })))
                self?.dataStore?.termCurrencies = Array(Set(currencies.compactMap({ $0.termCurrency })))
                self?.dataStore?.baseAndTermCurrencies = currencies.compactMap({ [$0.baseCurrency, $0.termCurrency] })
                self?.getQuote(isInitialLaunch: true)
            case .failure(let error):
                dump(error)
            }
        }
    }
    
    func updateRate(viewAction: SwapModels.Rate.ViewAction) {
        getQuote(isInitialLaunch: false)
    }
    
    private func getQuote(isInitialLaunch: Bool) {
        guard let quoteTerm = dataStore?.quoteTerm else {
            let error = SwapErrors.noQuote
            lastError = error
            return
        }
        
        QuoteWorker().execute(requestData: QuoteRequestData(security: quoteTerm)) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.handleQuote(quote, isInitialLaunch: isInitialLaunch)
                
            case .failure(let error):
                self?.lastError = error
                self?.handleQuote(nil, isInitialLaunch: isInitialLaunch)
            }
        }
    }
    
    private func handleQuote(_ quote: Quote?, isInitialLaunch: Bool) {
        guard let baseCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedBaseCurrency })?.coinGeckoId,
              let termCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedTermCurrency })?.coinGeckoId else {
            
            normalFiatRate = 0
            switchedFiatRate = 0
            self.quote = nil
            return
        }
        
        self.quote = quote
        let coinGeckoIds = [baseCurrency, termCurrency]
        let vs = dataStore?.defaultCurrencyCode?.lowercased() ?? ""
        let resource = Resources.simplePrice(ids: coinGeckoIds, vsCurrency: vs, options: [.change]) { (result: Result<[SimplePrice], CoinGeckoError>) in
            guard case .success(let data) = result, let quote = quote else { return }
            let basePrice = data.first(where: { $0.id == baseCurrency })
            let termPrice = data.first(where: { $0.id == termCurrency })
            
            self.normalFiatRate = NSDecimalNumber(value: basePrice?.price ?? 0.0).decimalValue
            self.switchedFiatRate = NSDecimalNumber(value: termPrice?.price ?? 0.0).decimalValue
            
            self.quoteTimeStamp = quote.timestamp
            self.bidCryptoRate = quote.closeBid
            self.askCryptoRate = 1 / quote.closeAsk
            
            if isInitialLaunch {
                self.presenter?.presentData(actionResponse: .init(item: nil))
            }
            
            self.presenter?.presentUpdateRate(actionResponse: .init(baseCurrency: self.dataStore?.selectedBaseCurrency,
                                                                    termCurrency: self.dataStore?.selectedTermCurrency,
                                                                    baseRate: self.bidCryptoRate,
                                                                    termRate: self.askCryptoRate,
                                                                    rateTimeStamp: self.quoteTimeStamp))
            self.setAmount(viewAction: .init())
        }
        
        CoinGeckoClient().load(resource)
    }
    
    private func estimateFee(amount: Decimal?, currencyCode: String?, completion: @escaping ((Result<Amount, Error>) -> Void)) {
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
                completion(.success(Amount(cryptoAmount: fee.fee, currency: currency)))
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func getBaseCurrencyImage() -> UIImage? {
        guard let baseCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedBaseCurrency }) else { return nil }
        
        return baseCurrency.imageSquareBackground
    }
    
    private func getTermCurrencyImage() -> UIImage? {
        guard let termCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedTermCurrency }) else { return nil }
        
        return termCurrency.imageSquareBackground
    }
    
    private func getBaseBalance() -> Amount? {
        guard let baseCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedBaseCurrency }),
              let baseBalance = baseCurrency.state?.balance else { return nil }
        
        return baseBalance
    }
    
    func switchPlaces(viewAction: SwapModels.SwitchPlaces.ViewAction) {
        let base = dataStore?.selectedBaseCurrency
        let term = dataStore?.selectedTermCurrency
        dataStore?.selectedBaseCurrency = term
        dataStore?.selectedTermCurrency = base
        
        let bid = bidCryptoRate
        let ask = askCryptoRate
        bidCryptoRate = ask
        askCryptoRate = bid
        
        dataStore?.minMaxToggleValue = nil
        dataStore?.fromCryptoAmount = nil
        dataStore?.toCryptoAmount = nil
        dataStore?.fromFiatAmount = nil
        dataStore?.toFiatAmount = nil
        
        presenter?.presentUpdateRate(actionResponse: .init(baseCurrency: dataStore?.selectedBaseCurrency,
                                                           termCurrency: dataStore?.selectedTermCurrency,
                                                           baseRate: bidCryptoRate,
                                                           termRate: askCryptoRate,
                                                           rateTimeStamp: quoteTimeStamp))
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
                guard (getBaseBalance()?.fiatValue ?? 0) >= minAmount else {
                    lastError = SwapErrors.tooLow
                    setAmount(viewAction: .init())
                    
                    return
                }
                viewAction.fromCryptoAmount = "\(getBaseBalance()?.tokenValue ?? 0)"
            }
        }
        
        let group = DispatchGroup()
        group.enter()
        estimateFee(amount: dataStore?.fromCryptoAmount, currencyCode: dataStore?.selectedBaseCurrency) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.fromBaseCryptoFee = fee.tokenValue
                self?.dataStore?.fromBaseFiatFee = fee.fiatValue
                
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        estimateFee(amount: dataStore?.toCryptoAmount, currencyCode: dataStore?.selectedTermCurrency) { [weak self] result in
            switch result {
            case .success(let fee):
                self?.dataStore?.fromTermCryptoFee = fee.tokenValue
                self?.dataStore?.fromTermFiatFee = fee.fiatValue
                
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [unowned self] in
            if let fromCryptoAmount = viewAction.fromCryptoAmount {
                guard let fromPrice = quote?.closeAsk else { return }
                
                let from = NSDecimalNumber(string: fromCryptoAmount).decimalValue
                let to = (from - (dataStore?.fromBaseCryptoFee ?? 0)) * fromPrice - (dataStore?.fromTermCryptoFee ?? 0)
                
                dataStore?.fromCryptoAmount = from
                dataStore?.toCryptoAmount = to
                dataStore?.fromFiatAmount = from * normalFiatRate
                dataStore?.toFiatAmount = to * switchedFiatRate
            } else if let fromFiatAmount = viewAction.fromFiatAmount {
                guard let fromPrice = quote?.closeAsk else { return }
                
                let fromFiat = NSDecimalNumber(string: fromFiatAmount).decimalValue
                let fromCrpto = fromFiat / normalFiatRate
                let to = (fromCrpto - (dataStore?.fromBaseCryptoFee ?? 0)) * fromPrice - (dataStore?.fromTermCryptoFee ?? 0)
                
                dataStore?.fromFiatAmount = fromFiat
                dataStore?.fromCryptoAmount = fromCrpto
                dataStore?.toFiatAmount = to * switchedFiatRate
                dataStore?.toCryptoAmount = to
            } else if let toCryptoAmount = viewAction.toCryptoAmount {
                guard let fromPrice = quote?.closeBid else { return }
                
                let to = NSDecimalNumber(string: toCryptoAmount).decimalValue
                let from = (to + (dataStore?.fromTermCryptoFee ?? 0)) / fromPrice + (dataStore?.fromBaseCryptoFee ?? 0)
                
                dataStore?.toCryptoAmount = to
                dataStore?.toFiatAmount = to * switchedFiatRate
                dataStore?.fromCryptoAmount = from
                dataStore?.fromFiatAmount = from * normalFiatRate
            } else if let toFiatAmount = viewAction.toFiatAmount {
                guard let fromPrice = quote?.closeBid else { return }
                
                let toFiat = NSDecimalNumber(string: toFiatAmount).decimalValue
                let toCrypto = (toFiat - (dataStore?.fromTermFiatFee ?? 0)) / switchedFiatRate
                let from = (toCrypto + (dataStore?.fromTermCryptoFee ?? 0)) / fromPrice + (dataStore?.fromBaseCryptoFee ?? 0)
                
                dataStore?.toCryptoAmount = toCrypto
                dataStore?.toFiatAmount = toCrypto
                dataStore?.fromCryptoAmount = from
                dataStore?.fromFiatAmount = from * normalFiatRate
            } else if dataStore?.fromCryptoAmount == nil
                        && dataStore?.fromFiatAmount == nil
                        && dataStore?.toCryptoAmount == nil
                        && dataStore?.toFiatAmount == nil {
                dataStore?.toCryptoAmount = 0
                dataStore?.toFiatAmount = 0
                dataStore?.fromCryptoAmount = 0
                dataStore?.fromFiatAmount = 0
                dataStore?.fromBaseCryptoFee = 0
                dataStore?.fromBaseFiatFee = 0
                dataStore?.fromTermCryptoFee = 0
                dataStore?.fromTermFiatFee = 0
                lastError = nil
            }
            
            guard let baseBalance = getBaseBalance(), let dataStore = dataStore else {
                lastError = SwapErrors.general
                return
            }
            
            presenter?.presentSetAmount(actionResponse: .init(fromFiatAmount: dataStore.fromFiatAmount,
                                                                    fromCryptoAmount: dataStore.fromCryptoAmount,
                                                                    toFiatAmount: dataStore.toFiatAmount,
                                                                    toCryptoAmount: dataStore.toCryptoAmount,
                                                                    fromBaseFiatFee: dataStore.fromBaseFiatFee,
                                                                    fromBaseCryptoFee: dataStore.fromBaseCryptoFee,
                                                                    fromTermFiatFee: dataStore.fromTermFiatFee,
                                                                    fromTermCryptoFee: dataStore.fromTermCryptoFee,
                                                                    baseCurrency: dataStore.selectedBaseCurrency,
                                                                    baseCurrencyIcon: getBaseCurrencyImage(),
                                                                    termCurrency: dataStore.selectedTermCurrency,
                                                                    termCurrencyIcon: getTermCurrencyImage(),
                                                                    minMaxToggleValue: dataStore.minMaxToggleValue,
                                                                    baseBalance: baseBalance))
            
            presenter?.presentError(actionResponse: .init(error: lastError))
            lastError = nil
        }
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        if let asset = viewAction.from {
            dataStore?.selectedBaseCurrency = asset
        }
        
        if let asset = viewAction.to {
            dataStore?.selectedTermCurrency = asset
        }
        
        dataStore?.toCryptoAmount = nil
        dataStore?.toFiatAmount = nil
        dataStore?.fromCryptoAmount = nil
        dataStore?.fromFiatAmount = nil
        dataStore?.minMaxToggleValue = nil
        
        getQuote(isInitialLaunch: false)
    }
    
    func selectAsset(viewAction: SwapModels.Assets.ViewAction) {
        var from: [String]?
        var to: [String]?
        
        if viewAction.to == true {
            to = dataStore?.supportedCurrencies?.compactMap { item in
                guard item.baseCurrency == dataStore?.selectedBaseCurrency else {
                    return nil
                }
                return item.termCurrency
            }
        } else {
            from = dataStore?.baseCurrencies
        }
        
        presenter?.presentSelectAsset(actionResponse: .init(from: from, to: to))
    }
    
    // MARK: - Aditional helpers
}
