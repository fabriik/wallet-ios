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

struct SwapDetailsExchangesResponseData: ModelResponse {
    var exchanges: [SwapDetailsResponseData]
}

struct SwapDetailsResponseData: ModelResponse {
    struct SourceDestination: ModelResponse {
        var currency: String?
        var currencyAmount: Double?
        var usdAmount: Double?
        var transactionId: String?
    }
    
    var orderId: Int?
    var status: TransactionStatus?
    var statusDetails: String?
    var source: SourceDestination?
    var destination: SourceDestination?
    var timestamp: Int?
}

struct SwapDetail: Model {
    struct SourceDestination: Model {
        var currency: String
        var currencyAmount: Double
        var usdAmount: Double
        var transactionId: String
    }
    
    var orderId: Int
    var status: TransactionStatus
    var statusDetails: String
    var source: SourceDestination
    var destination: SourceDestination
    var timestamp: Int
}

class SwapDetailsMapper: ModelMapper<SwapDetailsExchangesResponseData, [SwapDetail]> {
    override func getModel(from response: SwapDetailsExchangesResponseData?) -> [SwapDetail] {
        return response?
            .exchanges
            .compactMap { return
                SwapDetail(orderId: Int($0.orderId ?? 0),
                           status: TransactionStatus(rawValue: $0.status?.rawValue ?? "") ?? .pending,
                           statusDetails: $0.statusDetails ?? "",
                           source: SwapDetail.SourceDestination(currency: $0.source?.currency?.uppercased() ?? "",
                                                                currencyAmount: $0.source?.currencyAmount ?? 0,
                                                                usdAmount: $0.source?.usdAmount ?? 0,
                                                                transactionId: $0.source?.transactionId ?? ""),
                           destination: SwapDetail.SourceDestination(currency: $0.destination?.currency?.uppercased() ?? "",
                                                                     currencyAmount: $0.destination?.currencyAmount ?? 0,
                                                                     usdAmount: $0.destination?.usdAmount ?? 0,
                                                                     transactionId: $0.destination?.transactionId ?? ""),
                           timestamp: Int($0.timestamp ?? 0)) } ?? []
    }
}

class ExchangeHistoryWorker: BaseApiWorker<SwapDetailsMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.history.url
    }
}
