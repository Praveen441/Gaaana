//
//  HomeManagerProtocol.swift
//  GaanaAssignment
//
//  Created by praveen.agnihotri on 19/12/20.
//

import Foundation

protocol HomeManagerProtocol {
    
    var networkManager: NetworkManagerProtocol? {get}
    
    func fetchResponse(completion: @escaping HomeCompletionClosure)
}
