//
//  PlaylistRepository.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

protocol PlaylistRepositoryProtocol: BaseRepositoryProtocol {}

class PlaylistRepository: PlaylistRepositoryProtocol {
    
    typealias T = Playlist
    
    func getAll() -> [Playlist]? {
        let allCDPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(managedObjectType: CDPlaylist.self)
        var allPlaylists = [Playlist]()
        
        allCDPlaylists?.forEach({ (cdPlaylist) in
            allPlaylists.append(cdPlaylist.convertToPlaylist())
        })
        return allPlaylists
    }
    
    func getRecord(by id: String) -> Playlist? {
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", id)
        let cdPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDPlaylist.self)
        if let cdPlaylists = cdPlaylists, !cdPlaylists.isEmpty {
            return cdPlaylists.first?.convertToPlaylist()
        }
        return nil
    }
    
    func deleteRecord(for id: String) -> Bool {
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", id)
        return PersistentStorage.sharedInstance.deleteRecord(predicate: predicate, managedObjectType: CDPlaylist.self)
    }
    
    func delete(playlist: Playlist) -> Bool {
        guard let name = playlist.name else {return false}
        return deleteRecord(for: name)
    }
    
    func delete(track: Track, from playlist: Playlist) -> Bool {
        guard let name = playlist.name, let trackId = track.trackId else {return false}
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", name)
        let cdPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDPlaylist.self)
        if let cdPlaylists = cdPlaylists, !cdPlaylists.isEmpty {
            let cdPlaylist = cdPlaylists.first
            guard let cdTracks = cdPlaylist?.tracks, !cdTracks.isEmpty else {return false}
            let newCDTracks = cdTracks.filter {$0.trackId != trackId}
            cdPlaylist?.tracks = newCDTracks
            PersistentStorage.sharedInstance.saveContext()
            return true
        }
        return false
    }
    
    func update(record: Playlist) {
        guard let name = record.name else {return}
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", name)
        let cdPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDPlaylist.self)
        if let cdPlaylists = cdPlaylists, !cdPlaylists.isEmpty {
            let recordToUpdate = cdPlaylists.first
            recordToUpdate?.tracks = getCDTracks(tracks: record.tracks)
        }
        PersistentStorage.sharedInstance.saveContext()
    }
    
    func add(track: Track, toPlaylist: Playlist) -> Bool {
        /// If playlist is found then procedd else return
        guard let name = toPlaylist.name, var existingPlaylist = getRecord(by: name) else {return false}
        /// If track already exists in the playlist then return else add in the playlist
        guard !trackExistsIn(playlist: existingPlaylist, track: track) else {return false}
        var trackObj = track
        trackObj.date = Date()
        existingPlaylist.tracks.append(trackObj)
        update(record: existingPlaylist)
        return true
    }
    
    func create(record: Playlist) -> Bool {
        guard let name = record.name, !playlistExists(name: name) else {return false}
        let cdPlaylist = CDPlaylist(context: PersistentStorage.sharedInstance.context)
        cdPlaylist.name = record.name
        if !record.tracks.isEmpty {
            cdPlaylist.tracks = getCDTracks(tracks: record.tracks)
        }
        PersistentStorage.sharedInstance.saveContext()
        return true
    }
    
    func saveAll(records: [Playlist]) {
        return
    }
    
    private func trackExistsIn(playlist: Playlist, track: Track) -> Bool {
        let found = playlist.tracks.filter { (playlisttrack) -> Bool in
            return playlisttrack.trackId == track.trackId
        }.first
        
        if let _ = found {
            return true
        }
        return false
    }
    
    private func getCDTracks(tracks: [Track]) -> Set<CDTrack> {
        var cdTracks = Set<CDTrack>()
        
        tracks.forEach { (track) in
            let cdTrack = CDTrack(context: PersistentStorage.sharedInstance.context)
            cdTrack.name = track.name
            cdTrack.trackId = track.trackId
            cdTrack.imageUrl = track.imageUrl
            cdTrack.date = track.date
            cdTracks.insert(cdTrack)
        }
        return cdTracks
    }
    
    private func playlistExists(name: String) -> Bool {
        if let _ = getRecord(by: name) {
            return true
        }
        return false
    }
}
