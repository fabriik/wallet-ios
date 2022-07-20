// 
//  SwapWorker.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapRequestData: RequestModelData {
    var quoteId: Int?
    var quantity: Decimal
    var termQuantity: Decimal?
    var destination: String?
    var destinationCurrency: String?
    
    func getParameters() -> [String: Any] {
        let params: [String: Any?] = [
           "quote_id": quoteId,
           "base_quantity": "\(quantity)",
           "destination": destination,
           "destination_currency": destinationCurrency
        ]
        
        return params.compactMapValues { $0 }
    }
}

struct SwapResponseData: ModelResponse {
    var exchangeId: Int
    var currency: String
    var amount: String
    var address: String
}

struct Swap: Model {
    var exchangeId: Int
    var currency: String
    var amount: Decimal
    var address: String
}

class SwapMapper: ModelMapper<SwapResponseData, Swap> {
    override func getModel(from response: SwapResponseData?) -> Swap? {
        guard let response = response,
              let amount = Decimal(string: response.amount)
        else { return nil }

        return .init(exchangeId: response.exchangeId, currency: response.currency, amount: amount, address: response.address)
    }
}

class SwapWorker: BaseApiWorker<SwapMapper> {
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(SwapEndpoints.exchange)
    }
}