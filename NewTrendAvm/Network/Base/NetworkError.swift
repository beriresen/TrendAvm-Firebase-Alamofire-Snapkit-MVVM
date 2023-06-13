//
//  NetworkError.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 * Burada Api kaynaklı oluşabilecek sorunlar için hatalar tanımlanıyor.
 * Sunucu hataları,
 * internet bağlantısı hataları,
 * Apiden gelen yanıtın geçersiz olması ve generic yapıya uymaması
 * gibi hataları burada tanımlayarak, oluşan hataları bu enum sayesinde gösterebiliyoruz.
 */
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
