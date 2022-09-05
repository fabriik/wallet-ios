// 
//  EstimateFeeWorker.swift
//  breadwallet
//
//  Created by Rok on 05/09/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct EstimateFeeRequestData: RequestModelData {
    var amount: Decimal?
    var currency: String?
    var destination: String?
    
    func getParameters() -> [String: Any] {
        let args: [String: Any?] = [
            "amount": amount,
            "currency": currency,
            "destination_address": destination
        ]
        
        return args.compactMapValues { $0 }
    }
}

struct EstimateFeeResponse: ModelResponse {
    var nativeFee: Decimal
    var currency: String
}

struct EstimateFee: Model {
    var fee: Decimal
    var currency: String
}

class EstimateFeeMapper: ModelMapper<EstimateFeeResponse, EstimateFee> {
    override func getModel(from response: EstimateFeeResponse?) -> EstimateFee? {
        return .init(fee: response?.nativeFee ?? 0,
                     currency: response?.currency ?? "ETH")
    }
}

class EstimateFeeWorker: BaseApiWorker<EstimateFeeMapper> {
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(SwapEndpoints.estimateFee)
    }
}
