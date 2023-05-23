//
//  FirebaseManager.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 11.05.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    
    static let instance = FirebaseManager()
    let fireDb = Firestore.firestore()
    

    public func fetchCollection<T>(collection: Collections, completion: @escaping (Swift.Result<Array<(documentID: String, data: T)>, FirebaseError>) -> Void) {
        guard let cartBy = Auth.auth().currentUser?.email else {      // Aktif kullanıcının email adresini al
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
            
            guard let snapshot = snapshot else {         // Snapshot nil ise, "Snapshot is nil." hata mesajını döndür
                completion(.failure(FirebaseError.queryFailed(message: "Snapshot is nil.")))
                return
            }
            
            var result: [(documentID: String, data: T)] = []         // Sonuç dizisi oluştur
            
            for document in snapshot.documents {         // Snapshot içindeki her belgeyi döngüye al
                if let data = document.data() as? T {
                    result.append((documentID: document.documentID, data: data))
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
