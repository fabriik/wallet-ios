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
//    var inFeeEstimate: [FeeEstimate] // Using WalletKit for this.
//    var outFeeEstimates: [FeeEstimate] // Using WalletKit for this.
//
//    struct FeeEstimate: ModelResponse {
//        var estimatedConfirmationIn: UInt64
//        var tier: String
//        var fee: Amount
//
//        struct Amount: ModelResponse {
//            var currencyId: String
//            var amount: String
//        }
//    }
}

struct Quote {
    var quoteId: Int
    var securityId: String
    var closeAsk: Decimal
    var closeBid: Decimal
    var timestamp: Double
//    var inFeeEstimate: [FeeEstimate]
//    var outFeeEstimates: [FeeEstimate]
    
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
                     timestamp: response.timestamp)
//                     inFeeEstimate: response.inFeeEstimate.compactMap({
//            .init(estimatedConfirmationIn: $0.estimatedConfirmationIn,
//                  tier: $0.tier,
//                  fee: Quote.FeeEstimate.Amount(currencyId: $0.fee.currencyId,
//                                                amount: $0.fee.amount)) }),
//                     outFeeEstimates: response.outFeeEstimates.compactMap({
//            .init(estimatedConfirmationIn: $0.estimatedConfirmationIn,
//                  tier: $0.tier,
//                  fee: Quote.FeeEstimate.Amount(currencyId: $0.fee.currencyId,
//                                                amount: $0.fee.amount)) }))
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData)?.security else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.quote, parameters: urlParams)
    }
}
