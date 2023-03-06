//
//  SignUpResponse.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import Foundation

struct SignUpResponse:Codable {
    let id:Int
    let email:String
    let username:String
    let password:String
    let name:Name
    let address:Adres
    let phone:String
}

