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
    var from: String?
    var to: String?
    
    func getParameters() -> [String: Any] {
        let params = [
            "from": from,
            "to": to
        ]
        return params.compactMapValues { $0 }
    }
}

struct QuoteModelResponse: ModelResponse {
    var quoteId: Int
    var exchangeRate: Decimal
    var barTime: Double
    var timestamp: Double
    
    var markup: Decimal
    var minimumValue: Decimal
    var maximumValue: Decimal
}

struct Quote {
    var quoteId: Int
    var exchangeRate: Decimal
    var timestamp: Double
    
    var markup: Decimal
    var minimumValue: Decimal
    var maximumValue: Decimal
    
}

class QuoteMapper: ModelMapper<QuoteModelResponse, Quote> {
    override func getModel(from response: QuoteModelResponse?) -> Quote? {
        guard let response = response else { return nil }

        return .init(quoteId: response.quoteId,
                     exchangeRate: response.exchangeRate,
                     timestamp: response.timestamp,
                     markup: response.markup,
                     minimumValue: response.minimumValue,
                     maximumValue: response.maximumValue)
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData),
              let from = urlParams.from,
              let to = urlParams.to
        else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.quote, parameters: from, to)
    }
}
