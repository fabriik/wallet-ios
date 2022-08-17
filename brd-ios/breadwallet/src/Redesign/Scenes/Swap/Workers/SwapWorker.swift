// 
//  SwapWorker.swift
//  breadwallet
//
//  Created by Rok on 20/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

struct SwapRequestData: RequestModelData {
    var deviceId: String?
    var quoteId: Int?
    var depositQuantity: Decimal
    var withdrawalQuantity: Decimal?
    var destination: String?
    var sourceInstrumentId: String?
    var nologCvv: String?
    
    func getParameters() -> [String: Any] {
        let params: [String: Any?] = [
            "device_id": deviceId,
            "quote_id": quoteId,
            "deposit_quantity": depositQuantity.description,
            "withdrawal_quantity": withdrawalQuantity?.description,
            "destination": destination,
            "source_instrument_id": sourceInstrumentId,
            "nolog_cvv": nologCvv
        ]
        
        return params.compactMapValues { $0 }
    }
}

struct SwapResponseData: ModelResponse {
    var exchangeId: Int?
    var currency: String?
    var amount: String?
    var address: String?
    var status: String?
    var paymentReference: String?
    var redirectUrl: String?
}

struct Swap: Model {
    var exchangeId: String?
    var currency: String?
    var amount: Decimal?
    var address: String?
    var status: AddCard.Status?
    var paymentReference: String?
    var redirectUrl: String?
}

class SwapMapper: ModelMapper<SwapResponseData, Swap> {
    override func getModel(from response: SwapResponseData?) -> Swap? {
        guard let response = response,
              let amount = Decimal(string: response.amount ?? "")
        else {
            return .init(status: .init(rawValue: response?.status) ?? .none,
                         paymentReference: response?.paymentReference,
                         redirectUrl: response?.redirectUrl)
        }
        
        return .init(exchangeId: "\(response.exchangeId ?? 0)",
                     currency: response.currency?.uppercased() ?? "",
                     amount: amount,
                     address: response.address)
    }
}

class SwapWorker: BaseApiWorker<SwapMapper> {
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(SwapEndpoints.exchange)
    }
}

struct EstimateFeeRequestData: RequestModelData {
    var amount: Decimal?
    var currency: String?
    var destination: String?
    
    func getParameters() -> [String: Any] {
        let args: [String: Any?] = [
            "amount": amount,
            "currency": currency,
            "destination_address": destination
        ]
        
        return args.compactMapValues { $0 }
    }
}

struct EstimateFeeResponse: ModelResponse {
    var estimatedFeeEth: Decimal
}

struct EstimateFee: Model {
    var fee: Decimal
}

class EstimateFeeMapper: ModelMapper<EstimateFeeResponse, EstimateFee> {
    override func getModel(from response: EstimateFeeResponse?) -> EstimateFee? {
        return .init(fee: response?.estimatedFeeEth ?? 0)
    }
}

class EstimateFeeWorker: BaseApiWorker<EstimateFeeMapper> {
    override func getMethod() -> HTTPMethod {
        return .post
    }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(SwapEndpoints.estimateFee)
    }
}
