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
    var deviceId: String?
    var quoteId: Int?
    var depositQuantity: Decimal
    var withdrawalQuantity: Decimal?
    var destination: String?
    
    func getParameters() -> [String: Any] {
        let params: [String: Any?] = [
            "device_id": deviceId,
           "quote_id": quoteId,
           "deposit_quantity": depositQuantity.description,
           "withdrawal_quantity": withdrawalQuantity?.description,
           "destination": destination
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
    var exchangeId: String
    var currency: String
    var amount: Decimal
    var address: String
}

class SwapMapper: ModelMapper<SwapResponseData, Swap> {
    override func getModel(from response: SwapResponseData?) -> Swap? {
        guard let response = response,
              let amount = Decimal(string: response.amount)
        else { return nil }

        return .init(exchangeId: "\(response.exchangeId)", currency: response.currency, amount: amount, address: response.address)
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
