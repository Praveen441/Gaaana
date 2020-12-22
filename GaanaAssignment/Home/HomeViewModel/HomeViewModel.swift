//
//  HomeViewModel.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

typealias homeReponseStatusCompletion = (_ status: Bool, _ error: String?) -> Void

class HomeViewModel {
    
    var homeManager: HomeManagerProtocol?
    var sectionCellVMs = [SectionCellViewModel]()
    
    init(homeManager: HomeManagerProtocol) {
        self.homeManager = homeManager
    }
    
    func fetchResponse(completion: @escaping homeReponseStatusCompletion) {
        homeManager?.fetchResponse { [weak self] response in
            switch response {
            case .success(let response):
                self?.createCellViewModel(sections: response)
                completion(true, nil)
            case .failure(let error):
                debugPrint("error receiving tracks \(error.decription)")
                completion(false, error.decription)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return sectionCellVMs.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func createCellViewModel(sections: [Section]) {
        sectionCellVMs = sections.map { SectionCellViewModel(name: $0.name, tracks: getTrackCellVMs(for: $0.tracks)) }
    }
    
    func getTrackCellVMs(for tracks: [Track]?) -> [TrackCellViewModel] {
        return tracks?.map { TrackCellViewModel(name: $0.name, trackId: $0.trackId, imageUrl: $0.imageUrl)} ?? []
    }
    
    func getTracksFor(section: Int) -> [TrackCellViewModel] {
        return sectionCellVMs[section].tracks
    }
}
