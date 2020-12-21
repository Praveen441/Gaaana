//
//  PlaylistViewModel.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

class PlaylistViewModel {
    
    var playlistCellVMs = [PlaylistCellViewModel]()
    var playlistManager: PlaylistManagerProtocol?
    
    init(playlistManager: PlaylistManagerProtocol) {
        self.playlistManager = playlistManager
    }
    
    func savePlaylist(playlist: PlaylistCellViewModel) -> Bool {
        guard let playlistManager = playlistManager else {return false}
        let playlistModel = convertToPlaylist(playlistCellVM: playlist)
        
        if playlistManager.savePlaylist(playlist: playlistModel) {
            playlistCellVMs.append(playlist)
            return true
        }
        return false
    }
    
    func fetchAllPlaylists() {
        guard let allPlaylists = playlistManager?.fetchAllPlaylists() else {return}
        playlistCellVMs = allPlaylists.map { convertToPlaylistCellVM(playlist: $0) }
    }
    
    func add(track: TrackCellViewModel, playlist: PlaylistCellViewModel) -> Bool {
        let trackModel = convertToTrack(trackCellVM: track)
        let playlistModel = convertToPlaylist(playlistCellVM: playlist)
        
        if let status = playlistManager?.add(track: trackModel, playlist: playlistModel) {
            return status
        }
        return false
    }
    
    func add(track: TrackCellViewModel, playlist: [PlaylistCellViewModel]) {
        playlist.forEach { (list) in
            _ = add(track: track, playlist: list)
        }
    }
    
    func delete(playlist: PlaylistCellViewModel) {
        let playlistModel = convertToPlaylist(playlistCellVM: playlist)
        let status = playlistManager?.delete(playlist: playlistModel)
        
        if let status = status, status {
            playlistCellVMs.removeAll { (list) -> Bool in
                playlist.name == list.name
            }
        }
    }
    
    func delete(track: TrackCellViewModel, from playlist: PlaylistCellViewModel) {
        let trackModel = convertToTrack(trackCellVM: track)
        let playlistModel = convertToPlaylist(playlistCellVM: playlist)
        let status = playlistManager?.delete(track: trackModel, from: playlistModel)
        
        if let status = status, status {
            let deleteFromPlaylist = playlistCellVMs.filter {$0.name == playlist.name}.first
            guard var playlistTracks = deleteFromPlaylist?.tracks else {return}
            playlistTracks.removeAll(where: { (playlistTrack) -> Bool in
                playlistTrack.trackId == track.trackId
            })
        }
    }
    
    //MARK:- Helper Methods
    private func convertToPlaylist(playlistCellVM: PlaylistCellViewModel) -> Playlist {
        return Playlist(name: playlistCellVM.name,
                        tracks: playlistCellVM.tracks.map { convertToTrack(trackCellVM: $0) } )
    }
    
    private func convertToTrack(trackCellVM: TrackCellViewModel) -> Track {
        return Track(name: trackCellVM.name, trackId: trackCellVM.trackId,
                     imageUrl: trackCellVM.imageUrl, date: trackCellVM.date)
    }
    
    private func convertToPlaylistCellVM(playlist: Playlist) -> PlaylistCellViewModel {
        let trackCellVM = playlist.tracks.map { convertToTrackCellVM(track: $0)}
        let sortedTracks = trackCellVM.sorted(by: { $0.date ?? Date() < $1.date ?? Date()})
        
        return PlaylistCellViewModel(name: playlist.name,
                                     tracks: sortedTracks,
                                              isSelected: false)
    }
    
    private func convertToTrackCellVM(track: Track) -> TrackCellViewModel {
        return TrackCellViewModel(name: track.name, trackId: track.trackId, imageUrl: track.imageUrl, date: track.date)
    }
}
