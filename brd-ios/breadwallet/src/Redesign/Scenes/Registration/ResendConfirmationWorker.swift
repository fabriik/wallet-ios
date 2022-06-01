// 
//  ResendConfirmationWorker.swift
//  breadwallet
//
//  Created by Rok on 01/06/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ResendConfirmationResponseData: ModelResponse {
}

struct ResendConfirmationData: Model {
}

struct ResendConfirmationWorkerRequest: RequestModelData {
    let code: String?
    
    func getParameters() -> [String: Any] {
        return [
            "confirmation_code": code ?? ""
        ]
    }
}

class ResendConfirmationWorker: BaseResponseWorker<ResendConfirmationResponseData,
                                      ResendConfirmationData,
                                      ModelMapper<ResendConfirmationResponseData, ResendConfirmationData>> {

    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.resend)
    }

    override func getParameters() -> [String: Any] {
        return requestData?.getParameters() ?? [:]
    }

    override func getMethod() -> EQHTTPMethod {
        return .post
    }
}
