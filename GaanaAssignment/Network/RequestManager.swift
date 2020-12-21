//
//  RequestManager.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

class RequestManager: RequestManagerProtocol {

    var baseURL: String {
        return APIEndPoints.baseURL.rawValue
    }

    var requestBody: Data?

    var headers: HTTPHeaders

    var httpMethod: HTTPMethod

    var path: String

    var url: URL?
    
    var request: URLRequest?

    init(httpMethod: HTTPMethod, requestBody: Data?, path: String) {
    
        self.requestBody = requestBody
        self.httpMethod = httpMethod
        self.path = path
        self.headers = ["Content-Type": "application/json"]
        self.url = URL(string: baseURL+path)
        
        createRequest()
    }
}

extension RequestManager {
    
     func createRequest() {
        guard let url = url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let updatedURL = URL(string: url) else {
                return
        }
        
        var urlRequest = URLRequest(url: updatedURL)
        urlRequest.httpMethod = httpMethod.rawValue
        if let body = requestBody {
            urlRequest.httpBody = body
        }
        
        for key in headers.keys {
            urlRequest.setValue(headers[key], forHTTPHeaderField: key)
        }
        request = urlRequest
    }
}
