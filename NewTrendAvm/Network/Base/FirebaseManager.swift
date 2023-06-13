//
//  FirebaseManager.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 *FirebaseManager sınıfımızda firebase  isteklerimizi gerçekleştiriyoruz.
 *Fetch metodunun amacı Firestore koleksiyonundan belgeleri almak ve bu belgeleri döndürmek.
 *Collections tipinden bir enum değeri. Bu, veritabanında hangi koleksiyondan belgelerin alınacağını belirtir.
*

 */

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    
    static let instance = FirebaseManager()
    let fireDb = Firestore.firestore()
    

    public func fetchCollection<T>(collection: Collections, completion: @escaping (Swift.Result<Array<(documentID: String, data: T)>, FirebaseError>) -> Void) {
        guard let cartBy = Auth.auth().currentUser?.email else {      // Aktif kullanıcının email adresini al. Eğer aktif bir kullanıcı yoksa, completion closure'ını FirebaseError.docCreationFailed hatası ile çağırır ve metoddan çıkar.
            completion(.failure(FirebaseError.docCreationFailed))
            return
        }
     
        let cartsRef = fireDb.collection(collection.rawValue)    // "" koleksiyona referans oluştur
        let userDocRef = cartsRef.whereField("userId", isEqualTo: cartBy)     // "userId" alanı, aktif kullanıcının email adresine eşit olan belgeleri getir

        
        userDocRef.getDocuments { (snapshot, error) in     // Belgeye erişim için asenkron bir sorgu yap
            if let error = error { // Hata varsa, FirebaseError tipinde hata döndür
                completion(.failure(FirebaseError.queryFailed(message: error.localizedDescription)))
                return
            }
            
            guard let snapshot = snapshot else {         // Snapshot nil ise, "Snapshot is nil." hata mesajını döndür.veritabanından gelen sorgu sonucunu temsil eden bir parametredir.
                completion(.failure(FirebaseError.queryFailed(message: "Snapshot is nil.")))
                return
            }
            
            var result: [(documentID: String, data: T)] = []         //snapshot değeri nil değilse, result adında bir dizi oluşturur. Sonuç dizisi oluştur
            
            for document in snapshot.documents {         // Snapshot içindeki her belgeyi döngüye al
                if let data = document.data() as? T { //Her belgenin verilerini document.data() metodu ile alır ve bu veriyi generic tip T'ye dönüştürmeye çalışır.
                    result.append((documentID: document.documentID, data: data)) //Eğer dönüşüm başarılı ise,  belge verilerini  result dizisine ekler.
                }
            }
            
            completion(.success(result))
        }
    }

    
}
enum Collections: String {
    case carts = "carts"
    case favorites = "favorites"
    
}
