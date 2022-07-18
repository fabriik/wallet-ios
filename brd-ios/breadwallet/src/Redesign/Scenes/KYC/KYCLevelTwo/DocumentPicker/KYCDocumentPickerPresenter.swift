//
//  KYCDocumentPickerPresenter.swift
//  breadwallet
//
//  Created by Rok on 07/06/2022.
//
//

import AVFoundation
import UIKit

final class KYCDocumentPickerPresenter: NSObject, Presenter, KYCDocumentPickerActionResponses {
    typealias Models = KYCDocumentPickerModels

    weak var viewController: KYCDocumentPickerViewController?

    // MARK: - KYCDocumentPickerActionResponses
    func presentData(actionResponse: FetchModels.Get.ActionResponse) {
        guard let documents = actionResponse.item as? Models.Item else { return }
     
        let sections: [Models.Sections] = [
            .title,
            .documents
        ]
        
        let sectionRows: [Models.Sections: [Any]] = [
            .title: [LabelViewModel.text("Select one of the following options:")],
            .documents: documents.compactMap { return NavigationViewModel(image: .imageName($0.imageName), label: .text($0.title)) }
        ]
        
        viewController?.displayData(responseDisplay: .init(sections: sections, sectionRows: sectionRows))
    }
    
    func presentTakePhoto(actionResponse: KYCDocumentPickerModels.Photo.ActionResponse) {
        var instructions: String?
        var confirmation: String?
        var checklist = [ChecklistItemViewModel]()
        
        // TODO: localize
        if actionResponse.isFront == true,
           actionResponse.document == .passport {
            instructions = "Make sure to capture the entire document"
            confirmation = "You have captured the entire document\nMake sure document details are clearly visible and within the frame"
            checklist = [ChecklistItemViewModel(title: .text("You have captured the entire document")),
                         ChecklistItemViewModel(title: .text("Make sure document details are clearly visible and within the frame"))]
        } else if actionResponse.isFront == true {
            instructions = "Make sure to capture the entire front page of the document"
            confirmation = "You have captured the entire front page of the document\nMake sure document details are clearly visible and within the frame"
            checklist = [ChecklistItemViewModel(title: .text("You have captured the entire front page of the document")),
                         ChecklistItemViewModel(title: .text("Make sure document details are clearly visible and within the frame"))]
        } else if actionResponse.isBack == true {
            instructions = "Make sure to capture the entire back page of the document"
            confirmation = "You have captured the entire back page of the document\nMake sure document details are clearly visible and within the frame"
            checklist = [ChecklistItemViewModel(title: .text("You have captured the entire back page of the document")),
                         ChecklistItemViewModel(title: .text("Make sure document details are clearly visible and within the frame"))]
        } else if actionResponse.isSelfie == true {
            instructions = "Make sure your face is in the frame and clearly visible"
            confirmation = "Make sure to capture the entire document.\nYour face is clearly visible."
            checklist = [ChecklistItemViewModel(title: .text("You have captured your entire face in the frame.")),
                         ChecklistItemViewModel(title: .text("Your face is clearly visible."))]
        }
        
        var device: AVCaptureDevice?
        
        if actionResponse.isSelfie {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        
        guard let device = device else { return }
        
        viewController?.displayTakePhoto(responseDisplay: .init(model: .init(instruction: .text(instructions),
                                                                             confirmation: .text(confirmation)),
                                                                device: device,
                                                                checklist: checklist))
    }
    
    func presentFinish(actionResponse: KYCDocumentPickerModels.Finish.ActionResponse) {
        viewController?.displayFinish(responseDisplay: .init())
    }

    // MARK: - Additional Helpers

}
