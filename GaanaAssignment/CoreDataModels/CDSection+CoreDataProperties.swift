//
//  CDSection+CoreDataProperties.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 21/12/20.
//
//

import Foundation
import CoreData


extension CDSection {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSection> {
        return NSFetchRequest<CDSection>(entityName: "CDSection")
    }

    @NSManaged public var name: String?
    @NSManaged public var tracks: Set<CDTrack>?

}

// MARK: Generated accessors for tracks
extension CDSection {

    @objc(addTracksObject:)
    @NSManaged public func addToTracks(_ value: CDTrack)

    @objc(removeTracksObject:)
    @NSManaged public func removeFromTracks(_ value: CDTrack)

    @objc(addTracks:)
    @NSManaged public func addToTracks(_ values: Set<CDTrack>)

    @objc(removeTracks:)
    @NSManaged public func removeFromTracks(_ values: Set<CDTrack>)

}

extension CDSection : Identifiable {

}
