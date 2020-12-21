//
//  CDTrack+Extension.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

extension CDTrack {
    
    func convertToTrack() -> Track {
        var track = Track()
        track.name = self.name
        track.trackId = self.trackId
        track.imageUrl = self.imageUrl
        return track
    }
}
