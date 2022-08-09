// 
//  CardsWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 05/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct PaymentCardsResponseData: ModelResponse {
    struct CardResponseData: ModelResponse {
        var type: String
        var number: String
        var expiration: String
        var cvv: String
    }
    var cards: [CardResponseData]
}

struct PaymentCard: ItemSelectable {
    var type: String?
    var number: String?
    var expiration: String?
    var cvv: String?
    var image: UIImage?
    
    var displayName: String? { return number }
    var displayImage: ImageViewModel? {
        guard let image = image else {
            return .imageName("card")
        }
        return .image(image)
    }
}

class PaymentCardsMapper: ModelMapper<PaymentCardsResponseData, [PaymentCard]> {
    override func getModel(from response: PaymentCardsResponseData?) -> [PaymentCard]? {
        return response?.cards.compactMap { return .init(type: $0.type, number: $0.number, expiration: $0.expiration, cvv: $0.cvv) }
    }
}

struct PaymentCardsRequestData: RequestModelData {
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class CardsWorker: BaseApiWorker<PaymentCardsMapper> {
    override func execute(requestData: RequestModelData? = nil, completion: Completion? = nil) {
        self.requestData = requestData
        self.completion = completion
        self.result = []
        
        self.result = [PaymentCard(number: "0000-0000-0000-0000",
                                   expiration: "11/27",
                                   cvv: "678"),
                       PaymentCard(number: "0000-0000-0000-0001",
                                   expiration: "11/28",
                                   cvv: "789")]
        
        if let data = result {
            completion?(.success(data))
        }
    }
    
    override func getUrl() -> String {
        return ""
    }
    
    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }
    
    override func getMethod() -> HTTPMethod {
        return .get
    }
}
