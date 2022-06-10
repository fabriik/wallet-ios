// 
// Created by Equaleyes Solutions Ltd
//

import Foundation

struct KYCUploadFrontBackWorkerUrlModelData: UrlModelData {
    func urlParameters() -> [String] {
        let sessionKey: String = "sessionKey=\(UserDefaults.kycSessionKeyValue)"
        
        return [sessionKey]
    }
}

struct KYCUploadFrontBackWorkerRequest: RequestModelData {
    let imageData: [KYCUploadViewController.Step: Data]
    
    func getParameters() -> [String: Any] {
        guard let frontData = imageData[.idFront], let backData = imageData[.idBack] else { return [:] }
        
        let value = [KYCUploadFrontBackWorker.frontKey: frontData,
                     KYCUploadFrontBackWorker.backKey: backData]
        
        return value
    }
}

struct KYCUploadFrontBackWorkerData: RequestModelData, UrlModelData {
    let workerRequest: KYCUploadFrontBackWorkerRequest
    let workerUrlModelData: KYCUploadFrontBackWorkerUrlModelData
    
    func getParameters() -> [String: Any] {
        return workerRequest.getParameters()
    }
    
    func urlParameters() -> [String] {
        return workerUrlModelData.urlParameters()
    }
}

class KYCUploadFrontBackWorker: KYCBasePlainResponseWorker {
    static let frontKey: String = "auto_upload_file"
    static let backKey: String = "auto_upload_file_back"
    
    override func executeMultipartRequest(requestData: RequestModelData? = nil, completion: BasePlainResponseWorker.Completion?) {

        super.executeMultipartRequest(requestData: requestData, completion: completion)
    }
    
    override func getUrl() -> String {
        guard let urlParams = (requestData as? KYCUploadFrontBackWorkerData)?.urlParameters() else { return "" }
        
        return APIURLHandler.getUrl(KYCEndpoints.uploadFrontBackImage, parameters: urlParams)
    }
    
    override func getMethod() -> EQHTTPMethod {
        return .post
    }
    
    override func getMultipartData() -> [MultipartMedia] {
        guard let getParameters = (requestData as? KYCUploadFrontBackWorkerData)?.getParameters(),
              let frontValue = getParameters[KYCUploadFrontBackWorker.frontKey] as? Data,
              let backValue = getParameters[KYCUploadFrontBackWorker.backKey] as? Data else { return [] }
  
        return [
            .init(with: frontValue,
                  fileName: UUID().uuidString,
                  forKey: KYCUploadFrontBackWorker.frontKey,
                  mimeType: .jpeg,
                  mimeFileFormat: .jpeg),
            .init(with: backValue,
                  fileName: UUID().uuidString,
                  forKey: KYCUploadFrontBackWorker.backKey,
                  mimeType: .jpeg,
                  mimeFileFormat: .jpeg)
        ]
    }
}
