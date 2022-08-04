// 
//  SupportedCurrenciesWorker.swift
//  breadwallet
//
//  Created by Rok on 04/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct SupportedCurrenciesResponseData: ModelResponse {
    var supportedCurrencies: [String]
}

struct SupportedCurrency {
    var name: String
}

class SupportedCurrenciesWorkerMapper: ModelMapper<SupportedCurrenciesResponseData, [SupportedCurrency]> {
    override func getModel(from response: SupportedCurrenciesResponseData?) -> [SupportedCurrency]? {
        return response?.supportedCurrencies.compactMap { return .init(name: $0) }
    }
}

class SupportedCurrenciesWorker: BaseApiWorker<SupportedCurrenciesWorkerMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.supportedCurrencies.url
    }
}
