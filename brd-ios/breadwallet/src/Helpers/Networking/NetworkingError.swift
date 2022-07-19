//
//  EQNetworking
//  Copyright © 2022 Equaleyes Ltd. All rights reserved.
//

import Foundation

enum NetworkingError: FEError {
    case general
    case noConnection
    /// Status code 103
    case parameterMissing
    /// Status code 105
    case sessionExpired
    
    var errorMessage: String {
        return "LOCALIZE"
    }
}

// TODO: are these working? add to above array or create a separate enum
//public struct NetworkingGeneralError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? ""
//    }
//    public var userInfo: [String: Any]?
//
//    public init() {}
//}
//
//public struct NetworkingNotFoundError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? ""
//    }
//    public var userInfo: [String: Any]?
//
//    public init() {}
//}
//
//public struct NetworkingBadRequestError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? ""
//    }
//    public var userInfo: [String: Any]?
//
//    public init() {}
//
//    public init(userInfo: [String: Any]) {
//        self.userInfo = userInfo
//    }
//}
//
//public struct NetworkingForbiddenError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? ""
//    }
//    public var userInfo: [String: Any]?
//
//    public init() {}
//}
//
//public struct NetworkingNoConnectionError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? ""
//    }
//    public var userInfo: [String: Any]?
//
//    public init() {}
//}
//
//public struct NetworkingCustomError: NetworkingError {
//    public var errorMessage: String {
//        return firstOccurringError() ?? customError
//    }
//
//    public var userInfo: [String: Any]?
//
//    private let customError: String
//
//    public init() {
//        customError = ""
//    }
//
//    public init(message: String) {
//        self.customError = message
//    }
//}

public class NetworkingErrorManager {
    static func getError(from response: HTTPURLResponse?, data: Data?, error: Error?) -> FEError? {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            return NetworkingError.noConnection
        }
        
        if let errorObject = ServerResponse.parse(from: data, type: ServerResponse.self),
           let error = handleServerError(error: errorObject.error) {
            return error
        }
        
        guard let response = response else {
            return NetworkingError.general
        }
        
        switch response.statusCode {
            // TODO: add to enum if needed
//        case 400:
//            return NetworkingBadRequestError(data: data)
//        case 401:
//            return NetworkingCustomError(data: data)
//        case 403:
//            return NetworkingForbiddenError(data: data)
//        case 404:
//            return NetworkingNotFoundError(data: data)
        case 500...599:
            return NetworkingError.general
        default:
            return nil
        }
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
