//
//  PlaylistManagerProtocol.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

protocol PlaylistManagerProtocol {
    
    var networkManager: NetworkManagerProtocol? {get}
    
    func savePlaylist(playlist: Playlist) -> Bool
    
    func fetchAllPlaylists() -> [Playlist]
    
    func add(track: Track, playlist: Playlist) -> Bool
    
    func delete(playlist: Playlist) -> Bool
    
    func delete(track: Track, from playlist: Playlist) -> Bool
}
