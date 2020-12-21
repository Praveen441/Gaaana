//
//  PlaylistManager.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

class PlaylistManager: PlaylistManagerProtocol {
    
    var networkManager: NetworkManagerProtocol?
    var playlistRepository: PlaylistRepository?
    
    init(networkManager: NetworkManagerProtocol?) {
        self.networkManager = networkManager
        playlistRepository = PlaylistRepository()
    }
    
    func savePlaylist(playlist: Playlist) -> Bool {
        if let repository = playlistRepository, let name = playlist.name {
            return repository.create(playlist: name)
        }
        return false
    }
    
    func fetchAllPlaylists() -> [Playlist] {
        return playlistRepository?.getAllPlayllists() ?? []
    }
    
    func add(track: Track, playlist: Playlist) -> Bool {
        if let status = playlistRepository?.add(track: track, toPlaylist: playlist) {
            return status
        }
        return false
    }
        
    func delete(playlist: Playlist) -> Bool {
        if let respository = playlistRepository {
            return respository.delete(playlist: playlist)
        }
        return false
    }
    
    func delete(track: Track, from playlist: Playlist) -> Bool {
        if let repository = playlistRepository {
            return repository.delete(track: track, from: playlist)
        }
        return false
    }
}
