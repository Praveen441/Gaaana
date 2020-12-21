//
//  HomeViewModel.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

typealias homeReponseStatusCompletion = (_ status: Bool, _ error: String?) -> Void

class HomeViewModel {
    
    var sections: [Section] = []
    var homeManager: HomeManagerProtocol?
    var homeCellVMs = [SectionCellViewModel]()
    
    init(homeManager: HomeManagerProtocol) {
        self.homeManager = homeManager
    }
    
    func fetchResponse(completion: @escaping homeReponseStatusCompletion) {
        homeManager?.fetchResponse { [weak self] response in
            switch response {
            case .success(let response):
                self?.sections = response
                self?.createCellViewModel()
                completion(true, nil)
            case .failure(let error):
                debugPrint("error receiving tracks \(error.decription)")
                completion(false, error.decription)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return homeCellVMs.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return 1
    }
    
    func createCellViewModel() {
        sections.forEach { (section) in
            let tracks = getTrackCellVMs(for: section.tracks)
            let sectionCellVM = SectionCellViewModel(name: section.name ?? "", tracks: tracks)
            homeCellVMs.append(sectionCellVM)
        }
    }
    
    func getTrackCellVMs(for tracks: [Track]?) -> [TrackCellViewModel] {
        var trackCellVMs = [TrackCellViewModel]()
        
        tracks?.forEach({ (track) in
            let trackCellVM = TrackCellViewModel(name: track.name ?? "", trackId: track.trackId ?? "", imageUrl: track.imageUrl ?? "")
            trackCellVMs.append(trackCellVM)
        })
        return trackCellVMs
    }
    
    func getTracksForSection(index: Int) -> [TrackCellViewModel] {
        return homeCellVMs[index].tracks
    }
}
