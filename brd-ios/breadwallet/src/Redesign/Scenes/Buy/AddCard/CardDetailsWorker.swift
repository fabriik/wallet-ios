// 
//  CardDetailsWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct CardDetailsResponseData: ModelResponse {
    struct PaymentInstruments: ModelResponse {
        var id: String?
        var fingerprint: String?
        var expiryMonth: Int?
        var expiryYear: Int?
        var scheme: String?
        var last4: String?
    }
    
    var paymentInstruments: [PaymentInstruments]
}

struct CardDetails: Model {
    var id: String
    var fingerprint: String
    var expiryMonth: Int
    var expiryYear: Int
    var scheme: String
    var last4: String
}

class CardDetailsMapper: ModelMapper<CardDetailsResponseData, [CardDetails]> {
    override func getModel(from response: CardDetailsResponseData?) -> [CardDetails] {
        return response?.paymentInstruments.compactMap {
            return CardDetails(id: $0.id ?? "",
                               fingerprint: $0.fingerprint ?? "",
                               expiryMonth: $0.expiryMonth ?? 0,
                               expiryYear: $0.expiryYear ?? 0,
                               scheme: $0.scheme ?? "",
                               last4: $0.last4 ?? "")
        } ?? []
    }
}

struct CardDetailsRequestData: RequestModelData {
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class CardDetailsWorker: BaseApiWorker<CardDetailsMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.paymentInstruments.url
    }
}
