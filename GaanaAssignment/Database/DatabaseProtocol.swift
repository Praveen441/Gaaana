//
//  DatabaseHelper.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

protocol BaseRepositoryProtocol {
    associatedtype T
    
    func getAll() -> [T]?
    func getRecord(by id: String) -> T?
    func deleteRecord(for id: String) -> Bool
    func update(record: T)
    func create(record: T) -> Bool
    func saveAll(records: [T])
}
