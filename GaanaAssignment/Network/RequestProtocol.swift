//
//  RequestMaangerProtocol.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

protocol RequestProtocol {
    
    typealias HTTPHeaders = [String: String]
    
    var baseURL: URL? {get}
    var requestBody: Data? {get}
    var headers: HTTPHeaders {get}
    var httpMethod: HTTPMethod {get}
    var path: String {get}
}

/// HTTP Methods GET, PUT, POST, DELETE
enum HTTPMethod: String {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
}

enum APIEndPoints: String {
    case tracks
    case baseURL = ""
}

extension APIEndPoints: RequestProtocol {
    var baseURL: URL? {
        return URL(string: "http://demo6646924.mockable.io")
    }
    
    var headers: HTTPHeaders {
        let header = ["Content-Type": "application/json"]
        return header
    }
    
    var path: String {
        switch self {
        case .tracks:
            return "/gaana_demo"
        default:
            return ""
        }
    }
    
    var requestBody: Data? {
        return nil
    }
 
    var httpMethod: HTTPMethod {
        return .GET
    }
}
