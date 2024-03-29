//
//  ProfilePresenter.swift
//  breadwallet
//
//  Created by Rok on 26/05/2022.
//
//

import UIKit

final class ProfilePresenter: NSObject, Presenter, ProfileActionResponses {
    
    typealias Models = ProfileModels

    weak var viewController: ProfileViewController?

    // MARK: - ProfileActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let status = item.status else { return }
        
        var infoView: InfoViewModel
        switch status {
        case .none, .email:
            infoView = Presets.VerificationInfoView.none
        case .emailPending, .levelTwo(.submitted):
            infoView = Presets.VerificationInfoView.pending
        case .levelOne, .levelTwo(.notStarted):
            infoView = Presets.VerificationInfoView.verified
        case .levelTwo(.levelTwo):
            infoView = Presets.VerificationInfoView.verifiedLevelTwo
        case .levelTwo(.expired), .levelTwo(.resubmit):
            infoView = Presets.VerificationInfoView.resubmit
        case .levelTwo(.declined):
            infoView = Presets.VerificationInfoView.declined
        }
        
        let sections: [Models.Section] = [
            .profile,
            .verification,
            .navigation
        ]
        
        var navigationModel = Models.NavigationItems.allCases
        if status != .levelTwo(.levelTwo) {
            navigationModel = [Models.NavigationItems.security,
                               Models.NavigationItems.preferences]
        }
        
        let sectionRows: [Models.Section: [Any]] = [
            .profile: [
                ProfileViewModel(name: item.title ?? "", image: item.image ?? "")
            ],
            .verification: [
                infoView
            ],
            .navigation: navigationModel.compactMap { $0.model }
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentPaymentCards(actionResponse: ProfileModels.PaymentCards.ActionResponse) {
        viewController?.displayPaymentCards(responseDisplay: .init(allPaymentCards: actionResponse.allPaymentCards))
    }
    
    func presentVerificationInfo(actionResponse: ProfileModels.VerificationInfo.ActionResponse) {
        let model = PopupViewModel(title: .text(L10n.Account.whyVerify),
                                   body: L10n.Account.verifyAccountText)
        
        viewController?.displayVerificationInfo(responseDisplay: .init(model: model))
    }
    
    func presentNavigation(actionResponse: ProfileModels.Navigate.ActionResponse) {
        let item = Models.NavigationItems.allCases[actionResponse.index]
        viewController?.displayNavigation(responseDisplay: .init(item: item))
    }
    
    // MARK: - Additional Helpers
    
}
