// 
//  ProfileWorker.swift
//  breadwallet
//
//  Created by Rok on 06/06/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import Foundation

struct ProfileResponseData: ModelResponse {
    var country: String?
    var dateOfBirth: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var kycStatus: String?
    var kycFailureReason: String?
    
    var exchangeLimits: ExchangeLimits?
    
    struct ExchangeLimits: Codable {
        var allowanceLifetime: Decimal
        var allowanceDaily: Decimal
        var allowancePerExchange: Decimal
        var usedLifetime: Decimal
        var usedDaily: Decimal
        var nextExchangeLimit: Decimal
    }
}

//    "email": "kenan.mmdv+160@outlook.com",
//    "first_name": "Rr",
//    "last_name": "Cr",
//    "date_of_birth": "1957-07-12",
//    "country": "AR",
//    "kyc_status": "kyc1",
//    "roles": ["customer", "verified", "kyc1"],
//    "exchange_limits": {
//        "allowance_lifetime": 10000,
//        "allowance_daily": 1000,
//        "allowance_per_exchange": 1000,
//        "used_lifetime": 0,
//        "used_daily": 0,
//        "next_exchange_limit": 1000
//    }
//}

struct Profile: Model {
    var country: String?
    var dateOfBirth: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var status: VerificationStatus
    var failureReason: String?
    var exchangeLimit: Decimal = 0
    var dailyLimit: Decimal = 0
    var lifetimeLimit: Decimal = 0
    var usedDaily: Decimal = 0
    var usedLifetime: Decimal = 0
    
    var dailyRemainingLimit: Decimal {
        return dailyLimit - usedDaily
    } 
    
    var lifetimeRemainingLimit: Decimal {
        return lifetimeLimit - usedLifetime
    }
}

class ProfileMapper: ModelMapper<ProfileResponseData, Profile> {
    override func getModel(from response: ProfileResponseData?) -> Profile? {
        return .init(country: response?.country,
                     dateOfBirth: response?.dateOfBirth,
                     firstName: response?.firstName,
                     lastName: response?.lastName,
                     email: response?.email,
                     status: .init(rawValue: response?.kycStatus)
                     , failureReason: response?.kycFailureReason,
                     exchangeLimit: response?.exchangeLimits?.nextExchangeLimit ?? 0,
                     dailyLimit: response?.exchangeLimits?.allowanceDaily ?? 0,
                     lifetimeLimit: response?.exchangeLimits?.allowanceLifetime ?? 0,
                     usedDaily: response?.exchangeLimits?.usedDaily ?? 0,
                     usedLifetime: response?.exchangeLimits?.usedLifetime ?? 0)
    }
}

struct ProfileRequestData: RequestModelData {
    func getParameters() -> [String: Any] {
        return [:]
    }
}

class ProfileWorker: BaseApiWorker<ProfileMapper> {
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.profile)
    }
}
