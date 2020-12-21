//
//  CDTrack+CoreDataProperties.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 21/12/20.
//
//

import Foundation
import CoreData


extension CDTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTrack> {
        return NSFetchRequest<CDTrack>(entityName: "CDTrack")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var trackId: String?
    @NSManaged public var date: Date?
    @NSManaged public var playlistRelationship: Set<CDPlaylist>?
    @NSManaged public var sectionRelationShip: CDSection?

}

// MARK: Generated accessors for playlistRelationship
extension CDTrack {

    @objc(addPlaylistRelationshipObject:)
    @NSManaged public func addToPlaylistRelationship(_ value: CDPlaylist)

    @objc(removePlaylistRelationshipObject:)
    @NSManaged public func removeFromPlaylistRelationship(_ value: CDPlaylist)

    @objc(addPlaylistRelationship:)
    @NSManaged public func addToPlaylistRelationship(_ values: Set<CDPlaylist>)

    @objc(removePlaylistRelationship:)
    @NSManaged public func removeFromPlaylistRelationship(_ values: Set<CDPlaylist>)

}

extension CDTrack : Identifiable {

}
