//
//  Track.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 18/12/20.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    var status: Int?
    var sections: [Section]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case sections = "sections"
    }
}

// MARK: - Section
struct Section: Codable {
    var name: String?
    var tracks: [Track]?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case tracks = "tracks"
    }
}

// MARK: - Track
struct Track: Codable {
    var name: String?
    var trackId: String?
    var imageUrl: String?
    var date: Date?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case trackId = "itemID"
        case imageUrl = "atw"
    }
}
