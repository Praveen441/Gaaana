//
//  CDPlaylist+Extension.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//

import Foundation

extension CDPlaylist {
    
    func convertToPlaylist() -> Playlist {
        return Playlist(name: name, tracks: convertToTrackCellVM(tracks: tracks))
    }
    
    func convertToTrackCellVM(tracks: Set<CDTrack>?) -> [Track] {
        var trackCellVMs = [Track]()
        tracks?.forEach({ (cdTrack) in
            trackCellVMs.append(Track(name: cdTrack.name, trackId: cdTrack.trackId,
                                                   imageUrl: cdTrack.imageUrl, date: cdTrack.date))
        })
        return trackCellVMs
    }
}
