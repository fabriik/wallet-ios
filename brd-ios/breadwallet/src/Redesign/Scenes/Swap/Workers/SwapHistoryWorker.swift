// 
//  SwapHistoryWorker.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 25.7.22.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct SwapDetailsExchangesResponseData: ModelResponse {
    var exchanges: [SwapDetailsResponseData]
}

class SwapHistoryMapper: ModelMapper<SwapDetailsExchangesResponseData, [SwapDetail]> {
    override func getModel(from response: SwapDetailsExchangesResponseData?) -> [SwapDetail] {
        return response?
            .exchanges
            .compactMap { SwapDetailsMapper().getModel(from: $0) } ?? []
    }
}

class SwapHistoryWorker: BaseApiWorker<SwapHistoryMapper> {
    override func getUrl() -> String {
        return SwapEndpoints.history.url
    }
}
