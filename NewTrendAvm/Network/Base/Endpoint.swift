//
//  Endpoint.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 * Burada Alamofire kütüphanesi ile api entegrasyonları yaparken gerekli bilgiler için Protocol tanımlanıyor.
 * Bu yapı standart bir yapı olduğu için, farklı apiler için miras alınması için tasarlandı.
 * Bu projede TrendAvmEndPoint Bu protocolden miras alarak ilgili bilgileri tutuyor.
 * Extension ile bu protocole scheme ve host bilgilerini giriyoruz, bu sayede TrendAvmEndPoint içerisinde bu değerleri tekrar tekrar tanımlamamıza gerek kalmıyor,
 * diğer tanımlamalarda ise default bir değer tanımlanmadığı için miras alan TrendAvmEndPoint'e bir metot eklendiğinde path, method, param, header, body bilgilerinin girilmesi zorunlu hale geliyor.
 */
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
