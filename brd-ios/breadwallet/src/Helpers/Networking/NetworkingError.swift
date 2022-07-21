//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

protocol FEError: Error {
    var errorMessage: String { get }
}

struct GeneralError: FEError {
    var errorMessage: String = "Unknown error"
}

enum NetworkingError: FEError {
    case noConnection
    /// Status code 103
    case parameterMissing
    /// Status code 105
    case sessionExpired
    case unprocessableEntity
    var errorMessage: String {
        return "LOCALIZE"
    }
    
    init?(error: ServerResponse.ServerError?) {
        switch error?.statusCode {
        case 103:
            self = .parameterMissing
            
        case 105:
            self = .sessionExpired
            
        case 422:
            self = .unprocessableEntity
            
        default:
            return nil
        }
    }
}

public class NetworkingErrorManager {
    static func getError(from response: HTTPURLResponse?, data: Data?, error: Error?) -> FEError? {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            return NetworkingError.noConnection
        }
        
        let error = ServerResponse.parse(from: data, type: ServerResponse.self)?.error
    
        guard let error = NetworkingError(error: error) else { return error }
        
        return error
    }
    
    static func getImageUploadEncodingError() -> FEError? {
        // TODO: is this right?
        return GeneralError(errorMessage: "Image encoding failed.")
    }
    
    static fileprivate func isErrorStatusCode(_ statusCode: Int) -> Bool {
        if case 400 ... 599 = statusCode {
            return true
        }
        return false
    }
}
