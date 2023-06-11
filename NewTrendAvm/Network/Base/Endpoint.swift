//
//  Endpoint.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Alamofire

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var param: [String: String]? { get }
    var header: HTTPHeaders { get }
    var body: [String: String]? { get }
    var destination:URLEncoding.Destination? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "fakestoreapi.com"
    }
}


protocol CollPoint{
    var collection: String { get }
}
