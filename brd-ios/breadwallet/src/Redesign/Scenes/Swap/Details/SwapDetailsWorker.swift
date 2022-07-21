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
        case pending
    }
    
    struct Source: Codable {
        var currency: String
        var currencyAmount: Decimal
        var usdAmount: Decimal
        var transactionId: Int?
    }
    
    var orderId: Int
    var status: Status
    var source: Source
    var destination: Source
    var timestamp: Int
}

struct SwapDetails: Model {}

class SwapDetailsMapper: ModelMapper<SwapDetailsResponseData, SwapDetails> {}

class SwapDetailsWorker: BaseApiWorker<SwapDetailsMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? SwapDetailsRequestData)?.exchangeId else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.details, parameters: urlParams)
    }
}
