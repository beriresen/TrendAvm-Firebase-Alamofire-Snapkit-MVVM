//
//  NetworkError.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
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
