//
//  FirebaseEndPoint.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Foundation

enum FirebaseEndPoint{
    case carts(cartProduct: [String: Any])
    case favorites

}
extension FirebaseEndPoint:CollPoint{
    var collection: String {
        switch self {
        case .carts:
            return "carts"
        case .favorites:
            return "favorites"
        }
    }
    
}
