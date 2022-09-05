// 
//  FeeFetchable.swift
//  breadwallet
//
//  Created by Rok on 01/09/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation
import WalletKit

protocol FeeFetchable {
    // Maybe pass sender instead of wallet/keyStore/kvStore ?
    func fetchWkFee(for amount: Amount,
                    address: String,
                    wallet: Wallet?,
                    keyStore: KeyStore?,
                    kvStore: BRReplicatedKVStore?,
                    completion: @escaping ((TransferFeeBasis?) -> Void))
}

extension FeeFetchable {
    
    func fetchWkFee(for amount: Amount,
                    address: String,
                    wallet: Wallet?,
                    keyStore: KeyStore?,
                    kvStore: BRReplicatedKVStore?,
                    completion: @escaping ((TransferFeeBasis?) -> Void)) {
        guard let wallet = wallet,
        let keyStore = keyStore,
        let kvStore = kvStore
        else { return
        }

        let sender = Sender(wallet: wallet, authenticator: keyStore, kvStore: kvStore)
        sender.estimateFee(address: address,
                           amount: amount,
                           tier: .regular,
                           isStake: false) { result in
            switch result {
            case .success(let fee):
                completion(fee)
                
            case .failure:
                completion(nil)
            }
        }
    }
}
