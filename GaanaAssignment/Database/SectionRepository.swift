//
//  SectionRepository.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

protocol SectionRepositoryProtocol: BaseRepositoryProtocol {}

class SectionRespository: SectionRepositoryProtocol {

    typealias T = Section
    
    func getAll() -> [Section]? {
        var sections = [Section]()
        let response = PersistentStorage.sharedInstance.fetchManagedObject(managedObjectType: CDSection.self)
        response?.forEach({ (section) in
            sections.append(section.convertToSection())
        })
        return sections
    }
    
    func saveAll(records: [Section]) {
        records.forEach { (record) in
            let cdSection = CDSection(context: PersistentStorage.sharedInstance.context)
            cdSection.name = record.name
            
            if let tracks = record.tracks, !tracks.isEmpty {
                var cdTracks = Set<CDTrack>()
                
                record.tracks?.forEach({ (track) in
                    let cdTrack = CDTrack(context: PersistentStorage.sharedInstance.context)
                    cdTrack.name = track.name
                    cdTrack.trackId = track.trackId
                    cdTrack.imageUrl = track.imageUrl
                    cdTracks.insert(cdTrack)
                })
                cdSection.tracks = cdTracks
            }
        }
        PersistentStorage.sharedInstance.saveContext()
    }
    
    func getRecord(by id: String) -> Section? {
        return nil
    }
    
    func deleteRecord(for id: String) -> Bool {
        return true
    }
    
    func update(record: Section) {
        return
    }
    
    func create(record: Section) -> Bool {
        return true
    }
}
