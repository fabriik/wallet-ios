// 
//  SwapEndpoints.swift
//  breadwallet
//
//  Created by Rok on 04/07/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

enum ExchangeEndpoints: String, URLType {
    static var baseURL: String = "https://" + E.apiUrl + "blocksatoshi/exchange/%@"
    
    case supportedCurrencies = "supported-currencies"
    case quote = "quote?from=%@&to=%@"
    case exchange = "create"
    case details = "exchange/%@"
    case history = "exchanges"
    case paymentInstruments = "payment-instruments"
    case paymentInstrument = "payment-instrument"
    case paymentInstrumentId = "payment-instrument?instrument_id=%@"
    case paymentStatus = "payment-status?reference=%@"
    case estimateFee = "estimate-fee"
    
    var url: String {
        return String(format: Self.baseURL, rawValue)
    }
}
