//
//  HomeAPIManager.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

typealias HomeCompletionClosure = (Result<[Section], GaanaError>) -> Void

class HomeManager: HomeManagerProtocol {
    
    var networkManager: NetworkManagerProtocol?
    var sectionRespository: SectionRespository?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
        sectionRespository = SectionRespository()
    }
    
    func fetchResponse(completion: @escaping HomeCompletionClosure) {
        guard let sectionsInDB = sectionRespository?.getAllSection(), !sectionsInDB.isEmpty else {
            fetchResponseFromNetwork { [weak self] (successResponse) in
                switch successResponse {
                case .success(let response):
                    if let response = response as? Response, let sections = response.sections {
                        self?.sectionRespository?.saveAll(records: sections)
                        completion(.success(sections))
                    } else {
                        completion(.failure(.invalidData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(sectionsInDB))
    }
    
    func fetchResponseFromNetwork(completion: @escaping completionClosure) {
        let requestInstance = RequestManager(httpMethod: HTTPMethod.GET, requestBody: nil, path: APIEndPoints.tracks.rawValue)
        guard let request = requestInstance.request else {return}
        networkManager?.fetchDataWithURLRequest(request: request, decodingType: Response.self, completion: { (response) in
            completion(response)
        })
    }
}
