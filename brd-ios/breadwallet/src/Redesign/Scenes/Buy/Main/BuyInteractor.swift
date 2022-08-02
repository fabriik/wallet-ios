//
//  BuyInteractor.swift
//  breadwallet
//
//  Created by Rok on 01/08/2022.
//
//

import UIKit

enum BuyErrors: FEError {
    case noQuote
    
    var errorMessage: String {
        switch self {
        case .noQuote:
            return "no quote"
        }
    }
}

class BuyInteractor: NSObject, Interactor, BuyViewActions {
    typealias Models = BuyModels

    var presenter: BuyPresenter?
    var dataStore: BuyStore?

    // MARK: - BuyViewActions

    func getData(viewAction: FetchModels.Get.ViewAction) {
        guard let currency = dataStore?.fromCurrency else {
            return
        }
        
        getExchangeRate(viewAction: .init())
        presenter?.presentData(actionResponse: .init(item: Amount.zero(currency)))
    }
    
    func setAmount(viewAction: BuyModels.Amounts.ViewAction) {
        guard let rate = dataStore?.rate,
              let from = dataStore?.fromCurrency else {
            presenter?.presentError(actionResponse: .init(error: BuyErrors.noQuote))
            return
        }
        
        var tokenValue: Decimal?
        if let value = viewAction.tokenValue {
            tokenValue = decimalFor(amount: value)
        } else if let value = viewAction.fiatValue {
            tokenValue = (decimalFor(amount: value) ?? 0) / rate
        }

        guard let tokenString = formatAmount(amount: tokenValue) else { return }
        
        let amount = Amount(tokenString: tokenString, currency: from)
        presenter?.presentAmount(actionResponse: .init(amount: amount))
    }
    
    func getExchangeRate(viewAction: Models.Rate.ViewAction) {
        let coingeckoId = Store.state.currencies.first(where: { $0.code == viewAction.from })?.coinGeckoId
        
        guard let from = coingeckoId ?? dataStore?.fromCurrency?.coinGeckoId,
              let to = viewAction.to ?? dataStore?.toCurrency else {
            return
        }

        let resource = Resources.simplePrice(ids: [from],
                                             vsCurrency: to,
                                             options: [.change]) { [weak self] (result: Result<[SimplePrice], CoinGeckoError>) in
            switch result {
            case .success(let data):
                self?.dataStore?.rate = Decimal(data.first(where: { $0.id == from })?.price ?? 0)
                self?.presenter?.presentExchangeRate(actionResponse: .init(from: viewAction.from ?? self?.dataStore?.fromCurrency?.code,
                                                                           to: to,
                                                                           rate: self?.dataStore?.rate,
                                                                           expires: Date().timeIntervalSince1970 + 15))
                self?.setAmount(viewAction: .init(tokenValue: "1"))
                
            case .failure(let error):
                self?.presenter?.presentError(actionResponse: .init(error: error))
            }
        }
        
        CoinGeckoClient().load(resource)
    }
    
    func setAssets(viewAction: BuyModels.Assets.ViewAction) {
        if let value = viewAction.currency?.lowercased(),
           let currency = Store.state.currencies.first(where: { $0.code.lowercased() == value }) {
            dataStore?.fromCurrency = currency
            dataStore?.from = .init(tokenString: "1", currency: currency)
            getData(viewAction: .init())
        } else if let value = viewAction.card {
            // TODO: handle card selection
            print(value)
        }
        
        presenter?.presentAmount(actionResponse: .init(amount: dataStore?.from))
    }
    
    // MARK: - Aditional helpers
    private func decimalFor(amount: String?) -> Decimal? {
        guard let amount = amount else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8 //Int(currency.baseUnit.decimals)
        
        return formatter.number(from: amount)?.decimalValue
    }
    
    private func formatAmount(amount: Decimal?) -> String? {
        guard let amount = amount else {
            return nil
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8 //Int(currency.baseUnit.decimals)
        
        return formatter.string(for: amount)
    }
}
