//
//  TrendAvmEndPoint.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Alamofire
import Foundation

enum TrendAvmEndPoint{
    case products

}

extension TrendAvmEndPoint:Endpoint{
    var destination: Alamofire.URLEncoding.Destination? {
        switch self {
        case .products:
            return .queryString
        }
    }
    
    var path: String {
        switch self {
        case .products:
            return "/products"

        }
    }

    var method: HTTPMethod {
        switch self {
        case .products:
            return .get
        }
    }
    
    var param: [String : String]? {
        switch self {
        case .products:
            return [:]
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .products:
            return []

        }
    }
    
    var body: [String: String]? {
        switch self {
        case .products:
            return nil
        }
    }
}
