//
//  SignUpRequest.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import Foundation

struct SignUpRequest:Codable {
    var email:String
    var username:String
    var password:String
    var name:Name
    var address:Adres
    var phone:String
}
struct Name:Codable{
    var firstname:String
    var lastname:String
}
struct Adres:Codable{
    var city:String
    var street:String
    var number:Int
    var zipcode:String
    var  geolocation:Geo
}
struct Geo:Codable{
    var lat:String
    var long:String
}
