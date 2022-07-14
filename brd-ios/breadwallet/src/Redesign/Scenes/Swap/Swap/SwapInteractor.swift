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
                self?.dataStore?.baseCurrencies = Array(Set(currencies.compactMap({ $0.baseCurrency })))
                self?.dataStore?.termCurrencies = Array(Set(currencies.compactMap({ $0.termCurrency })))
                self?.dataStore?.baseAndTermCurrencies = currencies.compactMap({ [$0.baseCurrency, $0.termCurrency] })
                
                // TODO: REMOVE THIS. THIS IS FOR TESTING. CONNECT IT TO ASSET SELECTION
                self?.dataStore?.selectedBaseCurrency = "BCH"
                self?.dataStore?.selectedTermCurrency = "BSV"
                
                let quoteName = "BCH-BSV"
                QuoteWorker().execute(requestData: QuoteRequestData(security: quoteName)) { [weak self] result in
                    switch result {
                    case .success(let quote):
                        guard let baseCurrency = self?.dataStore?.currencies.first(where: { $0.code == self?.dataStore?.selectedBaseCurrency }) else { return }
                        
                        self?.bidCryptoRate = quote.closeBid
                        self?.askCryptoRate = 1 / quote.closeAsk
                        self?.quoteTimeStamp = quote.timestamp
                        
                        let coinGeckoIds = [baseCurrency.coinGeckoId ?? ""]
                        let vs = self?.dataStore?.defaultCurrencyCode?.lowercased() ?? ""
                        let resource = Resources.simplePrice(ids: coinGeckoIds, vsCurrency: vs, options: [.change]) { (result: Result<[SimplePrice], CoinGeckoError>) in
                            guard case .success(let data) = result else { return }
                            coinGeckoIds.forEach { id in
                                guard let self = self,
                                      let simplePrice = data.first(where: { $0.id == id }) else { return }
                                
                                self.normalFiatRate = NSDecimalNumber(value: simplePrice.price).decimalValue
                                self.switchedFiatRate = 1 / (self.normalFiatRate)
                                
                                self.presenter?.presentData(actionResponse: .init(item: Models.Item(baseRate: self.bidCryptoRate,
                                                                                                    termRate: self.askCryptoRate,
                                                                                                    rateTimeStamp: self.quoteTimeStamp,
                                                                                                    minMaxToggleValue: self.dataStore?.minMaxToggleValue)))
                                self.setAmount(viewAction: .init())
                            }
                        }
                        
                        CoinGeckoClient().load(resource)
                        
                    case .failure(let error):
                        dump(error)
                    }
                }
                
            case .failure(let error):
                dump(error)
            }
        }
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
            dataStore?.fromCryptoAmount = NSDecimalNumber(string: fromCryptoAmount.digits).decimalValue
            dataStore?.toCryptoAmount = (dataStore?.fromCryptoAmount ?? 0)
            
            dataStore?.fromFiatAmount = (dataStore?.fromCryptoAmount ?? 0)
            dataStore?.toFiatAmount = (dataStore?.fromFiatAmount ?? 0)
        }
        
        if let fromFiatAmount = viewAction.fromFiatAmount {
            dataStore?.fromFiatAmount = NSDecimalNumber(string: fromFiatAmount.digits).decimalValue
            dataStore?.toFiatAmount = (dataStore?.fromFiatAmount ?? 0)
            
            dataStore?.fromCryptoAmount = (dataStore?.fromFiatAmount ?? 0)
            dataStore?.toCryptoAmount = (dataStore?.fromCryptoAmount ?? 0)
        }
        
        if let toCryptoAmount = viewAction.toCryptoAmount {
            dataStore?.toCryptoAmount = NSDecimalNumber(string: toCryptoAmount.digits).decimalValue
            dataStore?.fromCryptoAmount = (dataStore?.toCryptoAmount ?? 0)
            
            dataStore?.fromFiatAmount = (dataStore?.fromCryptoAmount ?? 0)
            dataStore?.toFiatAmount = (dataStore?.fromFiatAmount ?? 0)
        }
        
        if let toFiatAmount = viewAction.toFiatAmount {
            dataStore?.toFiatAmount = NSDecimalNumber(string: toFiatAmount.digits).decimalValue
            dataStore?.fromFiatAmount = (dataStore?.toFiatAmount ?? 0)
            
            dataStore?.fromCryptoAmount = (dataStore?.toFiatAmount ?? 0)
            dataStore?.toCryptoAmount = (dataStore?.fromCryptoAmount ?? 0)
        }
        
        guard let baseBalance = getBaseBalance() else { return }
        presenter?.presentSetAmount(actionResponse: .init(fromFiatAmount: dataStore?.fromFiatAmount,
                                                          fromFiatAmountString: viewAction.fromFiatAmount,
                                                          fromCryptoAmount: dataStore?.fromCryptoAmount,
                                                          fromCryptoAmountString: viewAction.fromCryptoAmount,
                                                          toFiatAmount: dataStore?.toFiatAmount,
                                                          toFiatAmountString: viewAction.toFiatAmount,
                                                          toCryptoAmount: dataStore?.toCryptoAmount,
                                                          toCryptoAmountString: viewAction.toCryptoAmount,
                                                          fromBaseFiatFee: dataStore?.fromBaseFiatFee,
                                                          fromBaseCryptoFee: dataStore?.fromBaseCryptoFee,
                                                          fromTermFiatFee: dataStore?.fromTermFiatFee,
                                                          fromTermCryptoFee: dataStore?.fromTermCryptoFee,
                                                          baseCurrency: dataStore?.selectedBaseCurrency,
                                                          baseCurrencyIcon: getBaseCurrencyImage(),
                                                          termCurrency: dataStore?.selectedTermCurrency,
                                                          termCurrencyIcon: getTermCurrencyImage(),
                                                          minMaxToggleValue: dataStore?.minMaxToggleValue,
                                                          baseBalance: baseBalance))
    }
    
    func assetSelected(viewAction: SwapModels.SelectedAsset.ViewAction) {
        
    }
    
    // MARK: - Aditional helpers
}

extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber) }
}
