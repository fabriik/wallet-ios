//
//  PaymentsPresenter.swift
//  breadwallet
//
//  Created by Dijana Angelovska on 6.10.22.
//
//

import UIKit

final class PaymentsPresenter: NSObject, Presenter, PaymentsActionResponses {
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let item = actionResponse.item as? Models.Item,
              let items = item.items,
              let isAddingEnabled = item.isAddingEnabled
        else { return }
        
        var sections = [Models.Sections.items]
        if isAddingEnabled {
            sections.insert(Models.Sections.addItem, at: 0)
        }
        
        let sectionRows: [Models.Sections: [Any]] = [
            Models.Sections.items: items,
            Models.Sections.addItem: [L10n.Swap.addItem]
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    typealias Models = PaymentsModels

    weak var viewController: PaymentsViewController?

    // MARK: - PaymentsActionResponses
    func presentActionSheetRemovePayment(actionResponse: PaymentsModels.ActionSheet.ActionResponse) {
        viewController?.displayActionSheetRemovePayment(responseDisplay: .init(instrumentId: actionResponse.instrumentId,
                                                                               actionSheetOkButton: L10n.Buy.removePaymentMethod,
                                                                               actionSheetCancelButton: L10n.Button.cancel))
    }
    
    func presentRemovePaymentPopup(actionResponse: PaymentsModels.RemovePaymenetPopup.ActionResponse) {
        let popupViewModel = PopupViewModel(title: .text(L10n.Buy.removeCard),
                                            body: L10n.Buy.removeCardOption,
                                            buttons: [.init(title: L10n.Staking.remove),
                                                      .init(title: L10n.Button.cancel)],
                                            closeButton: .init(image: "close"))
        
        viewController?.displayRemovePaymentPopup(responseDisplay: .init(popupViewModel: popupViewModel,
                                                                    popupConfig: Presets.Popup.whiteDimmed))
    }
    
    func presentRemovePaymentMessage(actionResponse: PaymentsModels.RemovePayment.ActionResponse) {
        let model = InfoViewModel(description: .text(L10n.Buy.cardRemoved), dismissType: .auto)
        let config = Presets.InfoView.verification
        
        viewController?.displayMessage(responseDisplay: .init(model: model,
                                                              config: config))
        
        viewController?.displayRemovePaymentSuccess(responseDisplay: .init())
    }

    // MARK: - Additional Helpers

}
