// 
//  SwapDetailsWorker.swift
//  breadwallet
//
//  Created by Rok on 21/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct SwapDetailsRequestData: RequestModelData {
    var exchangeId: String?
    
    func getParameters() -> [String: Any] {
        let params = ["exchangeId": exchangeId]
        
        return params.compactMapValues { $0 }
    }
}

struct SwapDetailsResponseData: ModelResponse {
    enum Status: String, Codable {
        case pending = "PENDING"
        case complete = "COMPLETE"
        case failed = "FAILED"
    }
    
    struct Source: Codable {
        var currency: String
        var currencyAmount: Decimal
        var usdAmount: Decimal
        var transactionId: String?
    }
    
    var orderId: Int
    var status: Status
    var source: Source
    var destination: Source
    var timestamp: Int
}

struct SwapDetails: Model {
    var orderId: Int
    var timestamp: Int
    var status: SwapDetailsResponseData.Status
    
    var currency: String
    var currencyAmount: Decimal
    var usdAmount: Decimal
    var transactionId: String
    
    var currencyDestination: String
    var currencyAmountDestination: Decimal
    var usdAmountDestination: Decimal
    var transactionIdDestination: String
}

class SwapDetailsMapper: ModelMapper<SwapDetailsResponseData, SwapDetails> {
    override func getModel(from response: SwapDetailsResponseData?) -> SwapDetails? {
        guard let response = response else { return nil }
        
        return .init(orderId: response.orderId,
                     timestamp: response.timestamp,
                     status: response.status,
                     currency: response.source.currency.localizedUppercase,
                     currencyAmount: response.source.currencyAmount,
                     usdAmount: response.source.usdAmount,
                     transactionId: response.source.transactionId ?? "",
                     currencyDestination: response.destination.currency.localizedUppercase,
                     currencyAmountDestination: response.destination.currencyAmount,
                     usdAmountDestination: response.destination.usdAmount,
                     transactionIdDestination: response.destination.transactionId ?? "")
    }
}

class SwapDetailsWorker: BaseApiWorker<SwapDetailsMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? SwapDetailsRequestData)?.exchangeId else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.details, parameters: urlParams)
    }
}
