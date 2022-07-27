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
    var exchanges: [ExchangeResponseData]
}

struct ExchangeResponseData: ModelResponse {
    struct SourceDestination: ModelResponse {
        var currency: String?
        var currencyAmount: Double?
        var transactionId: String?
    }
    
    var orderId: Int?
    var status: TransactionStatus?
    var statusDetails: String?
    var source: SourceDestination?
    var destination: SourceDestination?
    var timestamp: UInt64?
}

struct Exchange: Model {
    struct SourceDestination: Model {
        var currency: String
        var currencyAmount: Double
        var transactionId: String?
    }
    
    var orderId: Int
    var status: TransactionStatus
    var statusDetails: String
    var source: SourceDestination
    var destination: SourceDestination
    var timestamp: Int
}

class ExchangeHistoryMapper: ModelMapper<ExchangesHistoryResponseData, [Exchange]> {
    override func getModel(from response: ExchangesHistoryResponseData?) -> [Exchange] {
        return response?
            .exchanges
            .compactMap { return
                Exchange(orderId: Int($0.orderId ?? 0),
                         status: TransactionStatus(rawValue: $0.status?.rawValue ?? "") ?? .pending,
                         statusDetails: $0.statusDetails ?? "",
                         source: Exchange.SourceDestination(currency: $0.source?.currency ?? "",
                                                            currencyAmount: $0.source?.currencyAmount ?? 0,
                                                            transactionId: $0.source?.transactionId),
                         destination: Exchange.SourceDestination(currency: $0.destination?.currency ?? "",
                                                                 currencyAmount: $0.destination?.currencyAmount ?? 0,
                                                                 transactionId: $0.destination?.transactionId),
                         timestamp: Int($0.timestamp ?? 0)) } ?? []
    }
}

class ExchangeHistoryWorker: BaseApiWorker<ExchangeHistoryMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.history.url
    }
}
