//
//  Presenter.swift
//  MagicFactory
//
//  Created by Rok Cresnik on 20/08/2021.
//

import UIKit

protocol Presenter: NSObject, BaseActionResponses {
    associatedtype ResponseDisplays: BaseResponseDisplays
    var viewController: ResponseDisplays? { get set }
}

extension Presenter {
    func presentError(actionResponse: MessageModels.Errors.ActionResponse) {
        guard let error = actionResponse.error else { return }

        let responseDisplay: MessageModels.ResponseDisplays
        if let error = error as? SessionExpiredError {
            responseDisplay = .init(error: error)
        } else if let error = error as? SwapErrors {
            let model = InfoViewModel(description: .text(error.errorMessage), dismissType: .persistent)
            let config = Presets.InfoView.swapError
            
            responseDisplay = .init(model: model, config: config)
        } else {
            // TODO: Investigate localized errors
            let message = (error as? NetworkingError)?.errorMessage ?? error.localizedDescription
            let model = InfoViewModel(headerTitle: .text("Error"), description: .text(message))
            
            // TODO: create Error preset
            let config = Presets.InfoView.primary
            responseDisplay = .init(model: model, config: config)
        }
    
        viewController?.displayMessage(responseDisplay: responseDisplay)
    }
    
    func presentNotification(actionResponse: MessageModels.Notification.ActionResponse) {
        let model = InfoViewModel(title: actionResponse.title != nil ?.text(actionResponse.title) : nil,
                                  description: actionResponse.body != nil ?.text(actionResponse.body) : nil,
                                  dismissType: actionResponse.dissmiss)
        
        // TODO: create notification preset
        let config = Presets.InfoView.primary
        
        viewController?.displayMessage(responseDisplay: .init(model: model, config: config))
    }
    
    func presentAlert(actionResponse: MessageModels.Alert.ActionResponse) {
        let model = InfoViewModel(title: .text(actionResponse.title),
                                  description: .text(actionResponse.body))
        
        // TODO: create alert preset
        let config = Presets.InfoView.primary
        viewController?.displayMessage(responseDisplay: .init(model: model, config: config))
    }
}
