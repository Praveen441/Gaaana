//
//  PlaylistRepository.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

protocol PlaylistRepositoryProtocol: BaseRepositoryProtocol {}

class PlaylistRepository: PlaylistRepositoryProtocol {
    
    typealias T = CDPlaylist
    
    func getAll() -> [CDPlaylist]? {
        return PersistentStorage.sharedInstance.fetchManagedObject(managedObjectType: CDPlaylist.self)
    }
    
    func getRecord(by id: String) -> CDPlaylist? {
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", id)
        let cdPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDPlaylist.self)
        if let cdPlaylists = cdPlaylists, !cdPlaylists.isEmpty {
            return cdPlaylists.first
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
    
    func update(record: CDPlaylist) {
    }
    
    func create(record: CDPlaylist) -> Bool {
        guard let _ = record.name else {return false}
        PersistentStorage.sharedInstance.saveContext()
        return true
    }
    
    func create(playlist name: String) -> Bool {
        guard !playlistExists(name: name) else {return false}
        let cdPlaylist = CDPlaylist(context: PersistentStorage.sharedInstance.context)
        cdPlaylist.name = name
        return create(record: cdPlaylist)
    }
    
    func delete(track: Track, from playlist: Playlist) -> Bool {
        guard let name = playlist.name, let trackId = track.trackId else {return false}
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.playlistName) == %@", name)
        let cdPlaylists = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDPlaylist.self)
        if let cdPlaylists = cdPlaylists, !cdPlaylists.isEmpty {
            let cdPlaylist = cdPlaylists.first
            guard let cdTracks = cdPlaylist?.tracks, !cdTracks.isEmpty else {return false}
            guard let trackToDelete = (cdTracks.filter {$0.trackId == trackId}).first else {return false}
            cdPlaylist?.tracks?.remove(trackToDelete)
            PersistentStorage.sharedInstance.saveContext()
            return true
        }
        return false
    }
    
    func getAllPlayllists() -> [Playlist] {
        let allPlaylists = getAll()
        var playlists = [Playlist]()
        
        allPlaylists?.forEach({ (cdPlaylist) in
            playlists.append(cdPlaylist.convertToPlaylist())
        })
        return playlists
    }
    
    func add(track: Track, toPlaylist: Playlist) -> Bool {
        /// If playlist is found then procedd else return
        guard let name = toPlaylist.name, let trackId = track.trackId, let existingPlaylist = getRecord(by: name) else {return false}
        /// If track already exists in the playlist then return else add in the playlist
        guard !trackExistsIn(playlist: existingPlaylist, track: track) else {return false}
        //// fetch track and set its playlist
        let predicate = NSPredicate(format: "\(Constants.CoreDataAttributes.trackId) == %@", trackId)
        let cdTracks = PersistentStorage.sharedInstance.fetchManagedObject(predicate: predicate, managedObjectType: CDTrack.self)
        if let cdTrack = cdTracks?.first {
            cdTrack.date = Date()
            cdTrack.playlist?.insert(existingPlaylist)
            PersistentStorage.sharedInstance.saveContext()
            return true
        }
        return false
    }
    
    func saveAll(records: [CDPlaylist]) {
        return
    }
    
    private func trackExistsIn(playlist: CDPlaylist, track: Track) -> Bool {
        let found = playlist.tracks?.filter { (playlisttrack) -> Bool in
            return playlisttrack.trackId == track.trackId
        }.first
        
        if let _ = found {
            return true
        }
        return false
    }
    
    private func playlistExists(name: String) -> Bool {
        if let _ = getRecord(by: name) {
            return true
        }
        return false
    }
}
