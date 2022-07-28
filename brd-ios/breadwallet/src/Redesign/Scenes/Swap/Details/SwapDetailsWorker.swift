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

class SwapDetailsMapper: ModelMapper<SwapDetailsResponseData, SwapDetail> {
    override func getModel(from response: SwapDetailsResponseData?) -> SwapDetail {
        return SwapDetail(orderId: Int(response?.orderId ?? 0),
                          status: TransactionStatus(rawValue: response?.status?.rawValue ?? "") ?? .pending,
                          statusDetails: response?.statusDetails ?? "",
                          source: SwapDetail.SourceDestination(currency: response?.source?.currency?.uppercased() ?? "",
                                                               currencyAmount: response?.source?.currencyAmount ?? 0,
                                                               usdAmount: response?.source?.usdAmount ?? 0,
                                                               transactionId: response?.source?.transactionId ?? ""),
                          destination: SwapDetail.SourceDestination(currency: response?.destination?.currency?.uppercased() ?? "",
                                                                    currencyAmount: response?.destination?.currencyAmount ?? 0,
                                                                    usdAmount: response?.destination?.usdAmount ?? 0,
                                                                    transactionId: response?.destination?.transactionId ?? ""),
                          timestamp: Int(response?.timestamp ?? 0))
    }
}

struct SwapDetailsRequestData: RequestModelData {
    var exchangeId: String?
    
    func getParameters() -> [String: Any] {
        let params = ["exchangeId": exchangeId]
        
        return params.compactMapValues { $0 }
    }
}

class SwapDetailsWorker: BaseApiWorker<SwapDetailsMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? SwapDetailsRequestData)?.exchangeId else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.details, parameters: urlParams)
    }
}
