//
//  NetworkManager.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

typealias completionClosure = (Result<Decodable, GaanaError>) -> Void

protocol NetworkManagerProtocol: class {
    func fetchDataWithURLRequest<T: Decodable>(request: RequestProtocol,
                                               decodingType: T.Type,
                                               completion: @escaping completionClosure)
}

class NetworkManager: NetworkManagerProtocol {
    
    private lazy var session: URLSession = {
       let session = URLSession(configuration: configuration)
        return session
    }()
    
    private lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        return configuration
    }()
    
    func fetchDataWithURLRequest<T: Decodable>(request: RequestProtocol,
                                               decodingType: T.Type,
                                               completion: @escaping completionClosure) {
    
        guard let request = getRequest(request: request) else {return}
        
        let task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let _ = response as? HTTPURLResponse else {
                completion(.failure(.serverError))
                return
            }
            
            guard error == nil else {
                completion(.failure(.clientError(error!)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            self?.parseResponse(response: data, type: T.self) { (response) in
                switch response {
                case .success(let parsedResponse):
                    completion(.success(parsedResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    private func getRequest(request: RequestProtocol) -> URLRequest? {
        guard let baseUrl = request.baseURL,
              let stringUrl = baseUrl.appendingPathComponent(request.path).absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: stringUrl) else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        if let body = request.requestBody {
            urlRequest.httpBody = body
        }
        
        for key in request.headers.keys {
            urlRequest.setValue(request.headers[key], forHTTPHeaderField: key)
        }
        return urlRequest
    }
    
    private func parseResponse<T: Decodable>(response: Data, type: T.Type, completion: completionClosure) {
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(Response.self, from: response)
            completion(.success(decodedResponse))
        } catch let error {
            debugPrint(error.localizedDescription)
            completion(.failure(.parsingError))
        }
    }
}
