//
//  SectionRepository.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

protocol SectionRepositoryProtocol: BaseRepositoryProtocol {}

class SectionRespository: SectionRepositoryProtocol {

    typealias T = CDSection
    
    func getAll() -> [CDSection]? {
        return PersistentStorage.sharedInstance.fetchManagedObject(managedObjectType: CDSection.self)
    }
    
    func getAllSection() -> [Section] {
        let allSections = getAll()
        var sections = [Section]()
        allSections?.forEach({ (section) in
            sections.append(section.convertToSection())
        })
        return sections
    }
    
    func saveAll(records: [CDSection]) {
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
    
    func getRecord(by id: String) -> CDSection? {
        return nil
    }
    
    func deleteRecord(for id: String) -> Bool {
        return true
    }
    
    func update(record: CDSection) {
        return
    }
    
    func create(record: CDSection) -> Bool {
        return true
    }
}
