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
    var security_id: String?
    var close_ask: Decimal?
    var close_bid: Decimal?
    var timestamp: Double?
    var in_fee_estimate: [FeeEstimate]? // Using WalletKit for this.
    var out_fee_estimates: [FeeEstimate]? // Using WalletKit for this.
    
    struct FeeEstimate: ModelResponse {
        var estimated_confirmation_in: UInt64?
        var tier: String?
        var fee: Amount?
        
        struct Amount: ModelResponse {
            var currency_id: String?
            var amount: String?
        }
    }
}

struct Quote {
    var securityId: String
    var closeAsk: Decimal
    var closeBid: Decimal
    var timestamp: Double
    var inFeeEstimate: [FeeEstimate]
    var outFeeEstimates: [FeeEstimate]
    
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
        return Quote(securityId: response?.security_id ?? "",
                     closeAsk: response?.close_ask ?? 0,
                     closeBid: response?.close_bid ?? 0,
                     timestamp: response?.timestamp ?? 0,
                     inFeeEstimate: response?.in_fee_estimate?.compactMap({
            Quote.FeeEstimate(estimatedConfirmationIn: $0.estimated_confirmation_in ?? 0,
                              tier: $0.tier ?? "",
                              fee: Quote.FeeEstimate.Amount(currencyId: $0.fee?.currency_id ?? "",
                                                            amount: $0.fee?.amount ?? "")) }) ?? [],
                     outFeeEstimates: response?.out_fee_estimates?.compactMap({
            Quote.FeeEstimate(estimatedConfirmationIn: $0.estimated_confirmation_in ?? 0,
                              tier: $0.tier ?? "",
                              fee: Quote.FeeEstimate.Amount(currencyId: $0.fee?.currency_id ?? "",
                                                            amount: $0.fee?.amount ?? "")) }) ?? [])
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData)?.security else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.quote, parameters: urlParams)
    }
}
