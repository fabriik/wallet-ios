//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

protocol FEError: Error {
    var errorMessage: String { get }
}

enum NetworkingError: FEError {
    case general
    case noConnection
    case custom
    /// Status code 103
    case parameterMissing
    /// Status code 105
    case sessionExpired
    
    var errorMessage: String {
        return "LOCALIZE"
    }
}

public class NetworkingErrorManager {
    static func getError(from response: HTTPURLResponse?, data: Data?, error: Error?) -> FEError? {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            return NetworkingError.noConnection
        }
        
        if let errorObject = ServerResponse.parse(from: data, type: ServerResponse.self),
           let error = handleServerError(error: errorObject.error) {
            return error
        }
        
        guard response != nil else { return NetworkingError.general }
        
        return ServerResponse.parse(from: data, type: ServerResponse.self)?.error
    }
    
    private static func handleServerError(error: ServerResponse.ServerError?) -> NetworkingError? {
        switch error?.statusCode {
        case 103:
            return NetworkingError.parameterMissing
            
        case 105:
            return NetworkingError.sessionExpired
            
            // TODO: handle other errors
        default:
            return nil
        }
    }
    
    static func getImageUploadEncodingError() -> NetworkingError {
        // TODO: is this right?
        return .general
    }
    
    static fileprivate func isErrorStatusCode(_ statusCode: Int) -> Bool {
        if case 400 ... 599 = statusCode {
            return true
        }
        return false
    }
}
