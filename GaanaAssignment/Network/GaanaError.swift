//
//  GaanaError.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

enum GaanaError: Error {
    
    case serverError
    case unknownError
    case unavailable
    case clientError(Error)
    case redirection
    case parsingError
    case invalidData
    
    var decription: String {
        switch self {
        case .serverError:
            return "Server Error"
        case .unknownError:
            return "unknown"
        case .unavailable:
            return "Unavailable"
        case .clientError(let error):
            return error.localizedDescription
        case .redirection:
            return "redirection Error"
        case .parsingError:
            return "Invalid JSON"
        case .invalidData:
            return "ErrorDataFormat"
        }
    }
}
