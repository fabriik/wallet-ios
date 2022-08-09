// 
//  AddCardWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct AddCardResponseData: ModelResponse {
    var status: String?
    var paymentReference: String?
    var redirectUrl: String?
}

struct AddCard: Model {
    enum Status: String, Codable {
        case ACTIVE
        case REQUESTED
        case PENDING
        case AUTHORIZED
        case CARDVERIFIED = "CARD_VERIFIED"
        case CANCELED
        case EXPIRED
        case PAID
        case DECLINED
        case VOIDED
        case PARTIALLYCAPTURED = "PARTIALLY_CAPTURED"
        case CAPTURED
        case PARTIALLYREFUNDED = "PARTIALLY_REFUNDED"
        case REFUNDED
    }
    
    var status: Status
    var paymentReference: String
    var redirectUrl: String?
}

class AddCardMapper: ModelMapper<AddCardResponseData, AddCard> {
    override func getModel(from response: AddCardResponseData?) -> AddCard {
        return AddCard(status: AddCard.Status(rawValue: response?.status ?? "") ?? .CANCELED,
                       paymentReference: response?.paymentReference ?? "",
                       redirectUrl: response?.redirectUrl)
    }
}

struct AddCardRequestData: RequestModelData {
    var token: String?
    
    func getParameters() -> [String: Any] {
        let params = ["token": token]
        
        return params.compactMapValues { $0 }
    }
}

class AddCardWorker: BaseApiWorker<AddCardMapper> {
    override func getUrl() -> String {
        guard let urlParams = (requestData as? AddCardRequestData)?.token else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.paymentInstrument, parameters: urlParams)
    }
}
