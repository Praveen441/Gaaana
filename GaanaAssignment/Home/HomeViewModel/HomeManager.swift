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
        networkManager?.fetchDataWithURLRequest(request: APIEndPoints.tracks, decodingType: Response.self, completion: { (response) in
            completion(response)
        })
    }
}
