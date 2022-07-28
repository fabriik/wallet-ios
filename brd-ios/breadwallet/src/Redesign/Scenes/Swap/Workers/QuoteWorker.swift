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
    var exchangeRate: Decimal
    var barTime: Double
    var timestamp: Double
    
    struct FeeEstimate: Codable {
        struct Fee: Codable {
            var currencyId: String
            var amount: String
        }
        var fee: Fee
        var estimatedConfirmationIn: Double
        var tier: String
    }
    
    var baseFeeEstimates: [FeeEstimate]
    var termFeeEstimates: [FeeEstimate]
    
    var buyMarkup: Decimal
    var sellMarkup: Decimal
    var minimumUsdValue: Decimal
}

struct Quote {
    var quoteId: Int
    var securityId: String
    var exchangeRate: Decimal
    var timestamp: Double
    
    struct FeeEstimate {
        struct Fee {
            var currencyId: String
            var amount: Decimal
        }
        var fee: Fee
        var estimatedConfirmationIn: Double
        var tier: String
    }
    
    var fromFee: [FeeEstimate]
    var toFee: [FeeEstimate]
    
    var buyMarkup: Decimal
    var sellMarkup: Decimal
    var minUsdAmount: Decimal
    
}

class QuoteMapper: ModelMapper<QuoteModelResponse, Quote> {
    override func getModel(from response: QuoteModelResponse?) -> Quote? {
        guard let response = response else { return nil }

        return .init(quoteId: response.quoteId,
                     securityId: response.securityId,
                     exchangeRate: response.exchangeRate,
                     timestamp: response.timestamp,
                     fromFee: response.baseFeeEstimates.compactMap { .init(fee: .init(currencyId: $0.fee.currencyId,
                                                                                      amount: Decimal(string: $0.fee.amount) ?? 0),
                                                                           estimatedConfirmationIn: $0.estimatedConfirmationIn,
                                                                           tier: $0.tier) },
                     toFee: response.termFeeEstimates.compactMap { .init(fee: .init(currencyId: $0.fee.currencyId,
                                                                                    amount: Decimal(string: $0.fee.amount) ?? 0),
                                                                         estimatedConfirmationIn: $0.estimatedConfirmationIn,
                                                                         tier: $0.tier) },
                     buyMarkup: response.buyMarkup,
                     sellMarkup: response.sellMarkup,
                     minUsdAmount: response.minimumUsdValue)
    }
}

class QuoteWorker: BaseApiWorker<QuoteMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? QuoteRequestData)?.security else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.quote, parameters: urlParams)
    }
}
