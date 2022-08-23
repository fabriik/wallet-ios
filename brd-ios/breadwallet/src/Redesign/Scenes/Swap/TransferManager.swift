// 
//  TransferManager.swift
//  breadwallet
//
//  Created by Rok on 23/08/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

class TransferManager {
    static let shared = TransferManager()
    private var worker: SwapHistoryWorker
    private var timer: Timer
    var exchanges: [SwapDetail]
    
    init() {
        worker = SwapHistoryWorker()
        exchanges = []
        
        timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: 60,
                                     repeats: true, block: { [weak self] _ in
            self?.reload()
        })
    }
    
    func reload(filter: Currency? = nil, completion: (([SwapDetail]?) -> Void)? = nil) {
        worker.execute { [weak self] result in
            let exchanges: [SwapDetail]
            switch result {
            case .success(let data):
                exchanges = data ?? []
                
            case .failure:
                exchanges = []
            }
            
            self?.exchanges = exchanges
            guard let filter = filter else {
                completion?(exchanges)
                return
            }
            completion?(self?.transactions(for: filter))
        }
    }
    
    func canSwap(_ currency: Currency?) -> Bool {
        guard exchanges.first(where: { $0.status == .pending && $0.source.currency == currency?.code }) == nil else {
            return false
        }
        return true
    }
    
    func transactions(for currency: Currency) -> [SwapDetail]? {
        return exchanges.filter { $0.destination.currency == currency.code }
    }
}
