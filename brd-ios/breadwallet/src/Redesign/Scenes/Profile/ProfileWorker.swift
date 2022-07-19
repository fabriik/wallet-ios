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
    
    var exchangeLimits: ExchangeLimits
    
    struct ExchangeLimits: Codable {
        var allowanceLifetime: Decimal
        var allowanceDaily: Decimal
        var allowancePerExchange: Decimal
        var usedLifetime: Decimal
        var usedDaily: Decimal
        var nextExchangeLimit: Decimal
    }
}

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
        guard let response = response else { return nil }

        return .init(country: response.country,
                     dateOfBirth: response.dateOfBirth,
                     firstName: response.firstName,
                     lastName: response.lastName,
                     email: response.email,
                     status: .init(rawValue: response.kycStatus),
                     failureReason: response.kycFailureReason,
                     exchangeLimit: response.exchangeLimits.nextExchangeLimit,
                     dailyLimit: response.exchangeLimits.allowanceDaily,
                     lifetimeLimit: response.exchangeLimits.allowanceLifetime,
                     usedDaily: response.exchangeLimits.usedDaily,
                     usedLifetime: response.exchangeLimits.usedLifetime)
    }
}

class ProfileWorker: BaseApiWorker<ProfileMapper> {
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.profile)
    }
}
