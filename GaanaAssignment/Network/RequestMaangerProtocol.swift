//
//  RequestMaangerProtocol.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

protocol RequestManagerProtocol {
    
    typealias HTTPHeaders = [String: String]
    
    var baseURL: String {get}
    var requestBody: Data? {get}
    var headers: HTTPHeaders {get}
    var httpMethod: HTTPMethod {get}
    var path: String {get}
    var url: URL? {get}
}

/// HTTP Methods GET, PUT, POST, DELETE
enum HTTPMethod: String {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
}

enum APIEndPoints: String {
    case tracks = "http://demo6646924.mockable.io/gaana_demo"
    case baseURL = ""
}
