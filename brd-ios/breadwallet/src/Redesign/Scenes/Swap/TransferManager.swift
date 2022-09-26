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
    private var exchanges: [SwapDetail]
    
    init() {
        worker = SwapHistoryWorker()
        exchanges = []
        
        timer = Timer()
        timer = Timer.scheduledTimer(withTimeInterval: C.secondsInMinute,
                                     repeats: true, block: { [weak self] _ in
            self?.reload()
        })
    }
    
    func reload(for source: String? = nil, completion: (([SwapDetail]?) -> Void)? = nil) {
        worker.execute { [weak self] result in
            let exchanges: [SwapDetail]
            switch result {
            case .success(let data):
                exchanges = data?.sorted(by: { $0.timestamp > $1.timestamp }) ?? []
                
            case .failure:
                exchanges = []
            }
            
            self?.exchanges = exchanges
            
            guard let source = source else {
                completion?(exchanges)
                return
            }
            completion?(exchanges.filter { $0.source.currency == source || $0.destination.currency == source })
        }
    }
    
    func canSwap(_ currency: Currency?) -> Bool {
        guard exchanges.first(where: { $0.status == .pending && $0.source.currency == currency?.code }) == nil else {
            return false
        }
        return true
    }
}
