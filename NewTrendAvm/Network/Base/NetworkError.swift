//
//  NetworkError.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
    
}

enum FirebaseError: Error {
    case docCreationFailed
    case docUpdateFailed
    case docAddFailed
    case docNotFound
    case userAuth
    case queryFailed(message: String)
    
}
