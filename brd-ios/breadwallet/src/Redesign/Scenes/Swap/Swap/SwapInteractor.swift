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

class SwapInteractor: NSObject, Interactor, SwapViewActions, Subscriber {
    
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
    
    // MARK: - SwapViewActions
    func getData(viewAction: FetchModels.Get.ViewAction) {
        SupportedCurrenciesWorker().execute { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.handleCurrencies(currencies)
                
                
            case .failure(let error):
                dump(error)
            }
        }
    }
    
    private func handleCurrencies(_ currencies: [SupportedCurrency]) {
        dataStore?.baseCurrencies = Array(Set(currencies.compactMap({ $0.baseCurrency })))
        dataStore?.termCurrencies = Array(Set(currencies.compactMap({ $0.termCurrency })))
        dataStore?.baseAndTermCurrencies = currencies.compactMap({ [$0.baseCurrency, $0.termCurrency] })
        
        // TODO: REMOVE THIS. THIS IS FOR TESTING. CONNECT IT TO ASSET SELECTION
        dataStore?.selectedBaseCurrency = "BCH"
        dataStore?.selectedTermCurrency = "BSV"
        
        guard let quoteTerm = dataStore?.quoteTerm else { return }
        
        QuoteWorker().execute(requestData: QuoteRequestData(security: quoteTerm)) { [weak self] result in
            switch result {
            case .success(let quote):
                self?.handleQuote(quote)
                
            case .failure(let error):
                dump(error)
            }
        }
    }
    
    private func handleQuote(_ quote: Quote?) {
        guard let baseCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedBaseCurrency })?.coinGeckoId,
              let termCurrency = dataStore?.currencies.first(where: { $0.code == dataStore?.selectedTermCurrency })?.coinGeckoId else { return }
        
        self.quote = quote
        let coinGeckoIds = [baseCurrency, termCurrency]
        let vs = dataStore?.defaultCurrencyCode?.lowercased() ?? ""
        let resource = Resources.simplePrice(ids: coinGeckoIds, vsCurrency: vs, options: [.change]) { (result: Result<[SimplePrice], CoinGeckoError>) in
            guard case .success(let data) = result else { return }
            let basePrice = data.first(where: { $0.id == baseCurrency })
            let termPrice = data.first(where: { $0.id == termCurrency })
            
            self.normalFiatRate = NSDecimalNumber(value: basePrice?.price ?? 0.0).decimalValue
            self.switchedFiatRate = NSDecimalNumber(value: termPrice?.price ?? 0.0).decimalValue
            
            self.presenter?.presentData(actionResponse: .init(item: Models.Item(baseRate: self.bidCryptoRate,
                                                                                termRate: self.askCryptoRate,
                                                                                rateTimeStamp: self.quoteTimeStamp,
                                                                                minMaxToggleValue: self.dataStore?.minMaxToggleValue)))
            self.setAmount(viewAction: .init())
        }
        
        CoinGeckoClient().load(resource)
    }
    
    private func estimateFee(amount: Decimal, currencyCode: String) {
        guard amount > 0, amount.isNaN == false else { return }
        
        guard let currency = dataStore?.currencies.first(where: { $0.code == currencyCode }) else { return }
        guard let wallet = dataStore?.coreSystem?.wallet(for: currency) else { return }
        guard let kvStore = Backend.kvStore, let keyStore = dataStore?.keyStore else { return }
        
        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        
        var addressScheme: AddressScheme
        if currency.isBitcoin {
            addressScheme = UserDefaults.hasOptedInSegwit ? .btcSegwit : .btcLegacy
        } else {
            addressScheme = currency.network.defaultAddressScheme
        }
        
        let address = currency.wallet?.receiveAddress(for: addressScheme) ?? ""
        let amount = Amount(tokenString: String(describing: amount.doubleValue), currency: currency)
        
        sender.estimateFee(address: address,
                           amount: amount,
                           tier: .regular,
                           isStake: false) { [weak self] result in
            switch result {
            case .success(let fee):
                break
//                self?.dataStore?.fromBaseCryptoFee = fee.fee.double(as: fee.fee.unit)
//                self?.dataStore?.fromBaseFiatFee = (fee.fee.double(as: fee.fee.unit) ?? 0) * (self?.normalFiatRate.doubleValue ?? 0)
                
//                self?.dataStore?.fromTermCryptoFee = fee.fee.double(as: fee.fee.unit)
//                self?.dataStore?.fromTermFiatFee = (fee.fee.double(as: fee.fee.unit) ?? 0) * (self?.switchedFiatRate.doubleValue ?? 0)
                
            case .failure:
                break
            }
        }
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
        
        presenter?.presentData(actionResponse: .init(item: Models.Item(baseRate: bidCryptoRate,
                                                                       termRate: askCryptoRate,
                                                                       rateTimeStamp: quoteTimeStamp,
                                                                       minMaxToggleValue: dataStore?.minMaxToggleValue)))
        setAmount(viewAction: .init())
    }
    
    func setAmount(viewAction: SwapModels.Amounts.ViewAction) {
        
        dataStore?.minMaxToggleValue = viewAction.minMaxToggleValue
        
        if let minMaxToggleValue = viewAction.minMaxToggleValue {
            switch minMaxToggleValue {
            case .min:
                dataStore?.fromFiatAmount = NSDecimalNumber(value: 50).decimalValue
                
            case .max:
                dataStore?.fromCryptoAmount = getBaseBalance()?.tokenValue
                
            }
        }
        
        if let fromCryptoAmount = viewAction.fromCryptoAmount {
            guard let fromPrice = quote?.closeAsk else { return }
            
            let from = NSDecimalNumber(string: fromCryptoAmount.digits).decimalValue
            let to = from * fromPrice
            
            dataStore?.fromCryptoAmount = from
            dataStore?.toCryptoAmount = to
            dataStore?.fromFiatAmount = from * normalFiatRate
            dataStore?.toFiatAmount = to * switchedFiatRate
        } else if let fromFiatAmount = viewAction.fromFiatAmount {
            guard let fromPrice = quote?.closeAsk else { return }
            let fromFiat = NSDecimalNumber(string: fromFiatAmount.digits).decimalValue
            let fromCrpto = fromFiat / normalFiatRate
            
            let to = fromCrpto * fromPrice
            
            dataStore?.fromFiatAmount = fromFiat
            dataStore?.fromCryptoAmount = fromCrpto
            dataStore?.toFiatAmount = to * switchedFiatRate
            dataStore?.toCryptoAmount = to
        } else if let toCryptoAmount = viewAction.toCryptoAmount {
            guard let fromPrice = quote?.closeBid else { return }
            
            let to = NSDecimalNumber(string: toCryptoAmount.digits).decimalValue
            let from = to / fromPrice
            
            dataStore?.toCryptoAmount = to
            dataStore?.toFiatAmount = to * switchedFiatRate
            dataStore?.fromCryptoAmount = from
            dataStore?.fromFiatAmount = from * normalFiatRate
        } else if let toFiatAmount = viewAction.toFiatAmount {
            guard let fromPrice = quote?.closeBid else { return }
            
            let toFiat = NSDecimalNumber(string: toFiatAmount.digits).decimalValue
            let toCrypto = toFiat / switchedFiatRate
            let from = toCrypto / fromPrice
            
            dataStore?.toCryptoAmount = toCrypto
            dataStore?.toFiatAmount = toCrypto
            dataStore?.fromCryptoAmount = from
            dataStore?.fromFiatAmount = from * normalFiatRate
        } else {
            return
        }
        
        guard let baseBalance = getBaseBalance() else { return }
        let model = Models.Amounts.ActionResponse(fromFiatAmount: dataStore?.fromFiatAmount,
                                                  fromCryptoAmount: dataStore?.fromCryptoAmount,
                                                  toFiatAmount: dataStore?.toFiatAmount,
                                                  toCryptoAmount: dataStore?.toCryptoAmount,
                                                  baseBalance: baseBalance)
        
        presenter?.presentSetAmount(actionResponse: model)
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        
    }
    
    // MARK: - Aditional helpers
}

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber) }
}
