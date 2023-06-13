//
//  NetworkManager.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 *NetworkManager sınıfımızda Api isteklerimizi gerçekleştiriyoruz.
 *Burada Api istekleri için kullandığımız kütüphane Alamofire.
 *Alamofire kütüphanesini kullanarak bir apinin tüm fonksiyonlarında aynı kod ile çalışabileceğimiz bir yapı oluşturuldu.
 *
 *Fetch fonksiyonu 2 adet parametre almakta.
 *Parametrelerden biri TrendAvmEndPoint içerisinde tanımlanan Enum
 *Parametrelerden diğeri Generic bir yapı kullanıldığı için Apiden gelen yanıtı istediğimiz nesneye dönüştürülmesi için kullanılıyor.
 *İlk parametrede istenilen enum içerisinde Alamofire kütüphanesi için gerekli Scheme, host, path vb. bilgiler bulunmakta.
 *
 *Dönüş tipi ise, istek başarılıysa belirttiğimiz Generic type nesnesi dönüyor,
 *Eğer herhangi bir hata ile karşılaşılmış ise Tanımladığımız NetworkError tipinde enum dönüyor. Bu dönen enum'a göre Switch-Case içerisinde ErrorAlert nesnesi kullanılıyor.
 */
import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    static let instance = NetworkManager()
    
    public func fetch<T:Codable> (endpoint: Endpoint,
                                  responseModel: T.Type,
                                  completed: @escaping (Swift.Result<T,NetworkError>) -> Void)
    {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        guard let url = urlComponents.url else {
            completed(.failure(.invalidURL))
            return
        }
        
        AF.request(url, method: endpoint.method, parameters: endpoint.param, encoding: URLEncoding(destination: endpoint.destination ?? .queryString), headers: endpoint.header)
            .validate()
            .responseData { response in
                
                if let _ =  response.error {
                    completed(.failure(.unableToComplete))
                    return
                }
                
                else if response.response?.statusCode != 200 {
                    completed(.failure(.invalidResponse))
                    return
                }
                
                guard response.data != nil else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                  print(response.data!)
                    let decodedResponse = try decoder.decode(T.self, from: response.data!)
                    completed(.success(decodedResponse))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
    }
}

