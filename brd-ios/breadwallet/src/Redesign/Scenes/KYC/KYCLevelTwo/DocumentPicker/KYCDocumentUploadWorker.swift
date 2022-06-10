// 
//  KYCDocumentUploadWorker.swift
//  breadwallet
//
//  Created by Rok on 10/06/2022.
//  Copyright © 2022 Fabriik Exchange, LLC. All rights reserved.
//
//  See the LICENSE file at the project root for license information.
//

import UIKit

protocol MultipartModelData: RequestModelData {
    
    func getMultipartData() -> [MultipartMedia]
}

struct KYCDocumentUploadRequestData: MultipartModelData {
    
    var front: UIImage?
    var back: UIImage?
    var selfie: UIImage?
    var documentyType: Document
    
    func getParameters() -> [String: Any] {
        guard documentyType != .selfie else {
            return [
                "type": documentyType.rawValue
            ]
        }
        
        return [
            "type": "ID",
            "document_type": documentyType.rawValue
        ]
    }
    
    func getMultipartData() -> [MultipartMedia] {
        var result: [String: Any?] = [
            "front": front,
            "back": back
        ]
        
        if documentyType == .selfie {
            result = ["front": selfie]
        }
        
        return result.compactMapValues { $0 }.compactMap {
            guard let image = $0.value as? UIImage,
                  let data = image.pngData() else { return nil }
            return .init(with: data, fileName: $0.key, forKey: $0.key, mimeType: .png, mimeFileFormat: .png)
        }
    }
}

class KYCDocumentUploadWorker: BasePlainResponseWorker {
    
    override func getMethod() -> EQHTTPMethod { return .post }
    
    override func getUrl() -> String {
        return APIURLHandler.getUrl(KYCAuthEndpoints.upload)
    }
    
    override func executeMultipartRequest(requestData: RequestModelData? = nil, completion: BasePlainResponseWorker.Completion?) {
        guard let uploadData = (requestData as? KYCDocumentUploadRequestData) else { return }
        
        self.data = uploadData.getMultipartData()
        super.executeMultipartRequest(requestData: requestData, completion: completion)
    }
    
}
