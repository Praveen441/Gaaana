//
//  CDPlaylist+CoreDataProperties.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 20/12/20.
//
//

import Foundation
import CoreData


extension CDPlaylist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPlaylist> {
        return NSFetchRequest<CDPlaylist>(entityName: "CDPlaylist")
    }

    @NSManaged public var name: String?
    @NSManaged public var tracks: Set<CDTrack>?

}

// MARK: Generated accessors for tracks
extension CDPlaylist {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: CDTrack)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: CDTrack)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: Set<CDTrack>)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: Set<CDTrack>)

}

extension CDPlaylist : Identifiable {

}
