//
//  CDSections+Extension.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

extension CDSection {
    
    func convertToSection() -> Section {
        var section = Section()
        section.name = self.name
        section.tracks = getTracks()
        return section
    }
    
    func getTracks() -> [Track] {
        var tracks = [Track]()
        self.tracks?.forEach({ (track) in
            tracks.append(track.convertToTrack())
        })
        return tracks
    }
}
