// 
//  DeleteCardWorker.swift
//  breadwallet
//
//  Created by Kenan Mamedoff on 09/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct DeleteCardRequestData: RequestModelData {
    var reference: String?
    
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class DeleteCardWorker: BaseApiWorker<AddCardMapper> {
    override func getMethod() -> HTTPMethod {
        return .delete
    }
    override func getUrl() -> String {
        guard let urlParams = (requestData as? DeleteCardRequestData)?.reference else { return "" }
        
        return APIURLHandler.getUrl(SwapEndpoints.paymentInstrumentId, parameters: urlParams)
    }
}

