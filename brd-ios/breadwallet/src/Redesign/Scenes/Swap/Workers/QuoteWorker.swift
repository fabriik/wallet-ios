// 
//  QuoteWorker.swift
//  breadwallet
//
//  Created by Rok on 04/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct QuoteRequestData: RequestModelData {
    var security: String?
    
    func getParameters() -> [String: Any] {
        return [:]
    }
}

struct QuoteModelResponse: ModelResponse {
    var quoteId: Int
    var securityId: String
    var closeAsk: Decimal
    var closeBid: Decimal
    var timestamp: Double
    var minimumUsdValue: Decimal
}

struct Quote {
    var quoteId: Int
    var securityId: String
    var closeAsk: Decimal
    var closeBid: Decimal
    var timestamp: Double
    var minUsdAmount: Decimal
    
    struct FeeEstimate {
        var estimatedConfirmationIn: UInt64
        var tier: String
        var fee: Amount
        
        struct Amount {
            var currencyId: String
            var amount: String
        }
    }
}

class QuoteMapper: ModelMapper<QuoteModelResponse, Quote> {
    override func getModel(from response: QuoteModelResponse?) -> Quote? {
        guard let response = response else { return nil }

        return .init(quoteId: response.quoteId,
                     securityId: response.securityId,
                     closeAsk: response.closeAsk,
                     closeBid: response.closeBid,
                     timestamp: response.timestamp,
                     minUsdAmount: response.minimumUsdValue)
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData)?.security else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.quote, parameters: urlParams)
    }
}
