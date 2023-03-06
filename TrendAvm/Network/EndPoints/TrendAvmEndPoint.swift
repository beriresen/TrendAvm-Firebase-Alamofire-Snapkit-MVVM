//
//  TrendAvmEndPoint.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import Alamofire
import Foundation

enum TrendAvmEndPoint{
    case login(request: LoginRequest)
    case addNewUser(request:SignUpRequest)
    case products

}

extension TrendAvmEndPoint:Endpoint{
    var destination: Alamofire.URLEncoding.Destination? {
        switch self {
        case .login:
            return .httpBody
        case .addNewUser:
            return .httpBody
        case .products:
            return .queryString
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .addNewUser:
            return "/users"
        case .products:
            return "/products"

        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .addNewUser:
            return .post
        case .products:
            return .get
        }
    }
    
    var param: [String : String]? {
        switch self {
        case .login(let request):
            return ["username": request.username,
                    "password":request.password]
        case .addNewUser(let request):
            return ["email": request.email,
                    "username": request.username,
                    "password": request.password,
                    "name": request.name.firstname,
                    "address": request.address.city,
                    "phone": request.phone]
        case .products:
            return [:]
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .login, .addNewUser:
            return []
        case .products:
            return []

        }
    }
    
    var body: [String: String]? {
        switch self {
        case .products:
            return nil
        case .login, .addNewUser:
            return nil
        }
    }
}
