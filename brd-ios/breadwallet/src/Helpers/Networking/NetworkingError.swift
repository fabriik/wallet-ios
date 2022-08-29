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
    case general
    case noConnection
    /// Status code 103
    case parameterMissing
    /// Status code 105
    case sessionExpired
    
    case sessionNotVerified
    
    case dataUnavailable
    
    case unprocessableEntity
    
    case serverAtCapacity
    
    var errorMessage: String {
        switch self {
        case .general:
            return "We are having temporary network issues. Please try again later."

        case .noConnection:
            return "Please, check your internet connection and try again later."
//        case .parameterMissing:
//            <#code#>
//        case .sessionExpired:
//            <#code#>
//        case .sessionNotVerified:
//            <#code#>
//        case .unprocessableEntity:
//            <#code#>
        case .serverAtCapacity:
            return "Oops! Something went wrong, please try again later."
            
        default:
            return "Unknown error."
        }
        
    } // TODO: Localize
    
    init?(error: ServerResponse.ServerError?) {
        switch error?.statusCode {
        case 103:
            self = .parameterMissing
            
        case 105:
            self = .sessionExpired
            
        case 403:
            self = .sessionNotVerified
            
        case 404:
            self = .dataUnavailable
            
        case 422:
            self = .unprocessableEntity
            
        case 503:
            self = .serverAtCapacity
            
        default:
            return nil
        }
    }
}

public class NetworkingErrorManager {
    static func getError(from response: HTTPURLResponse?, data: Data?, error: Error?) -> FEError? {
        if data?.isEmpty == true && error == nil {
            return nil
        }
        
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
