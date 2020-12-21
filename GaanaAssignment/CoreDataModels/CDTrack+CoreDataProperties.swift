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

    @NSManaged public var date: Date?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var trackId: String?
    @NSManaged public var playlist: Set<CDPlaylist>?
    @NSManaged public var section: CDSection?

}

// MARK: Generated accessors for playlist
extension CDTrack {

    @objc(addPlaylistObject:)
    @NSManaged public func addToPlaylist(_ value: CDPlaylist)

    @objc(removePlaylistObject:)
    @NSManaged public func removeFromPlaylist(_ value: CDPlaylist)

    @objc(addPlaylist:)
    @NSManaged public func addToPlaylist(_ values: Set<CDPlaylist>)

    @objc(removePlaylist:)
    @NSManaged public func removeFromPlaylist(_ values: Set<CDPlaylist>)

}

extension CDTrack : Identifiable {

}
