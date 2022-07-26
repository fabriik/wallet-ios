// 
//  ExchangeHistoryWorker.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 25.7.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ExchangesHistoryResponseData: ModelResponse {
    var exchanges: [ExchangeHistoryResponseData]
}

struct ExchangeHistoryResponseData: ModelResponse {
    enum Status: String, Codable {
        case pending = "PENDING"
        case complete = "COMPLETE"
        case failed = "FAILED"
    }
    
    struct Source: Codable {
        var currency: String
        var currencyAmount: Decimal
        var transactionId: Int?
    }
    
    struct Destination: Codable {
        var currency: String
        var currencyAmount: Decimal
    }
    
    var orderId: Int
    var status: Status
    var statusDetails: String
    var source: Source
    var destination: Destination
    var timestamp: Int
}

class ExchangeHistoryMapper: ModelMapper<ExchangesHistoryResponseData, [ExchangeHistoryResponseData]> {
    override func getModel(from response: ExchangesHistoryResponseData?) -> [ExchangeHistoryResponseData]? {
        return response?.exchanges
    }
}

class ExchangeHistoryWorker: BaseApiWorker<ExchangeHistoryMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.history.url
    }
}
