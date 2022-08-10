// 
//  PaymentCardsWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct PaymentCardsResponseData: ModelResponse {
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

struct PaymentCard: ItemSelectable {
    var id: String
    var fingerprint: String
    var expiryMonth: Int
    var expiryYear: Int
    var scheme: String
    var last4: String
    var image: UIImage?
    
    var displayName: String? { return CardDetailsFormatter.formatNumber(last4: last4) }
    var displayImage: ImageViewModel? {
        guard let image = image else {
            return .imageName("card")
        }
        return .image(image)
    }
}

class PaymentCardsMapper: ModelMapper<PaymentCardsResponseData, [PaymentCard]> {
    override func getModel(from response: PaymentCardsResponseData?) -> [PaymentCard] {
        return response?.paymentInstruments.compactMap {
            return PaymentCard(id: $0.id ?? "",
                               fingerprint: $0.fingerprint ?? "",
                               expiryMonth: $0.expiryMonth ?? 0,
                               expiryYear: $0.expiryYear ?? 0,
                               scheme: $0.scheme ?? "",
                               last4: $0.last4 ?? "")
        } ?? []
    }
}

struct PaymentCardsRequestData: RequestModelData {
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class PaymentCardsWorker: BaseApiWorker<PaymentCardsMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.paymentInstruments.url
    }
}
