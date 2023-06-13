//
//  ProductsViewModel.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class ProductsViewModel {
    //Observables. Bu nesnelerin değerleri değiştiğinde, ViewControllar içerisindeki dinleyici tetikleniyor

    var products = Observable<[Product]>()
    var isLoading = Observable<Bool>()
    var alertItem = Observable<AlertItem>()
    var cart = Observable<(Bool, Error?)>()
    var favorite = Observable<(Bool, Error?)>()
    
    func getProducts(){
        isLoading.value = true
        
        NetworkManager.instance.fetch(endpoint: TrendAvmEndPoint.products, responseModel: [Product].self){ [self] result in
            
            DispatchQueue.main.async { [self] in
                isLoading.value = false
                
                switch result {
                case .success(let result):
                    self.products.value = result
                    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        alertItem.value = AlertContext.invalidData
                        
                    case .invalidURL:
                        alertItem.value = AlertContext.invalidURL
                        
                    case .invalidResponse:
                        alertItem.value = AlertContext.invalidResponse
                        
                    case .unableToComplete:
                        alertItem.value = AlertContext.unableToComplete
                    }
                }
            }
        }
    }
    
    func addCart(productData: [String: Any], newCart: [String: Any]) -> Observable<(Bool, Error?)> {
        
        guard let userId = Auth.auth().currentUser?.email else {     // Kullanıcının kimlik doğrulamasını kontrol et
            cart.value = (false, FirebaseError.userAuth)
            return cart
        }
        DispatchQueue.main.async {  // Firestore üzerinden carts koleksiyonunu getir
            
            FirebaseManager.instance.fetchCollection(collection: .carts) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let carts):   // Kullanıcının sepetini kontrol et
                    if let userCart = carts.first(where: { $0.data["userId"] as? String == userId }) {
                        let cartId = userCart.documentID
                        var products = userCart.data["products"] as? [[String: Any]] ?? []
                        
                        let existingProductIndex = products.firstIndex(where: {
                            $0["productId"] as? Int == productData["productId"] as? Int
                        })
                        
                        if existingProductIndex != nil {
                            // Ürün zaten sepete eklenmişse hata döndür
                            self.cart.value = (false, FirebaseError.docAddFailed)
                        } else {
                            // Ürünü sepete ekle
                            products.append(productData)
                            
                            let cartsRef = Firestore.firestore().collection(Collections.carts.rawValue)
                            cartsRef.document(cartId).updateData(["products": products]) { error in
                                if error != nil {
                                    self.cart.value = (false, FirebaseError.docUpdateFailed)
                                } else {
                                    self.cart.value = (true, nil)
                                }
                            }
                        }
                    } else {
                        var updatedCart = newCart
                        updatedCart["products"] = [productData]
                        
                        let cartsRef = Firestore.firestore().collection(Collections.carts.rawValue)
                        cartsRef.addDocument(data: updatedCart) { error in
                            if error != nil {
                                self.cart.value = (false, FirebaseError.docCreationFailed)
                            } else {
                                self.cart.value = (true, nil)
                            }
                        }
                    }
                case .failure(let error):
                    self.cart.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        return cart
    }
    
    func increaseQuantity(productData: [String: Any], newCart: [String: Any]) -> Observable<(Bool, Error?)> {
        guard let userId = Auth.auth().currentUser?.email else {
            cart.value = (false, FirebaseError.userAuth)
            return cart
        }
        
        DispatchQueue.main.async {
            FirebaseManager.instance.fetchCollection(collection: .carts) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let carts):
                    if let userCart = carts.first(where: { $0.data["userId"] as? String == userId }) {
                        let cartId = userCart.documentID
                        var products = userCart.data["products"] as? [[String: Any]] ?? []
                        
                        let existingProductIndex = products.firstIndex(where: {
                            $0["productId"] as? Int == productData["productId"] as? Int
                        })
                        
                        if let existingProductIndex = existingProductIndex {
                            // Ürün zaten sepette var, adet ve fiyatı güncelle
                            var existingProduct = products[existingProductIndex]
                            var currentQuantity = existingProduct["productQuantity"] as? Int ?? 0
                            let currentPrice = existingProduct["productPrice"] as? Double ?? 0.0
                            
                            currentQuantity += 1
                            let totalPrice = currentPrice * Double(currentQuantity)
                            
                            existingProduct["productQuantity"] = currentQuantity
                            existingProduct["totalPrice"] = totalPrice
                            
                            products[existingProductIndex] = existingProduct
                            
                            let cartsRef = Firestore.firestore().collection(Collections.carts.rawValue)
                            cartsRef.document(cartId).updateData(["products": products]) { error in
                                if error != nil {
                                    self.cart.value = (false, FirebaseError.docUpdateFailed)
                                } else {
                                    self.cart.value = (true, nil)
                                }
                            }
                        } else {
                            // Ürün sepette yok, hata döndür
                            self.cart.value = (false, FirebaseError.docNotFound)
                        }
                    } else {
                        // Kullanıcının sepeti yok, hata döndür
                        self.cart.value = (false, FirebaseError.docNotFound)
                    }
                    
                case .failure(let error):
                    self.cart.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        
        return cart
    }
    
    func decreaseQuantity(productData: [String: Any], newCart: [String: Any]) -> Observable<(Bool, Error?)> {
        guard let userId = Auth.auth().currentUser?.email else {
            cart.value = (false, FirebaseError.userAuth)
            return cart
        }
        
        DispatchQueue.main.async {
            FirebaseManager.instance.fetchCollection(collection: .carts) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let carts):
                    if let userCart = carts.first(where: { $0.data["userId"] as? String == userId }) {
                        let cartId = userCart.documentID
                        var products = userCart.data["products"] as? [[String: Any]] ?? []
                        
                        let existingProductIndex = products.firstIndex(where: {
                            $0["productId"] as? Int == productData["productId"] as? Int
                        })
                        
                        if let existingProductIndex = existingProductIndex {
                            var existingProduct = products[existingProductIndex]
                            var currentQuantity = existingProduct["productQuantity"] as? Int ?? 0
                            let currentPrice = existingProduct["productPrice"] as? Double ?? 0.0
                            
                            if currentQuantity > 1 {
                                currentQuantity -= 1
                                let totalPrice = (existingProduct["totalPrice"] as? Double ?? 0.0) - currentPrice
                                
                                existingProduct["productQuantity"] = currentQuantity
                                existingProduct["totalPrice"] = totalPrice
                                
                                products[existingProductIndex] = existingProduct
                                
                                let cartsRef = Firestore.firestore().collection(Collections.carts.rawValue)
                                cartsRef.document(cartId).updateData(["products": products]) { error in
                                    if error != nil {
                                        self.cart.value = (false, FirebaseError.docNotFound)
                                    } else {
                                        self.cart.value = (false, FirebaseError.docNotFound)
                                    }
                                    self.cart.value = (false, FirebaseError.docNotFound)
                                }
                            } else {
                                // Ürün adeti 1'den az ise uyarı göster
                                self.cart.value = (false, FirebaseError.docNotFound)
                                
                            }
                        } else {
                            // Ürün sepette yok, hata döndür
                            self.cart.value = (false, FirebaseError.docNotFound)
                        }
                    } else {
                        // Kullanıcının sepeti yok, hata döndür
                        self.cart.value = (false, FirebaseError.docNotFound)
                    }
                    
                case .failure(let error):
                    self.cart.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        return cart
    }
    
    func getCart(completion: @escaping ([[String: Any]]) -> Void) {
        FirebaseManager.instance.fetchCollection(collection: .carts) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
            switch result {
            case .success(let carts):
                var products: [[String: Any]] = []
                
                for cart in carts {
                    let data = cart.data
                    
                    if let cartsBy = data["cartsBy"] as? String, cartsBy == Auth.auth().currentUser?.email {
                        if let productList = data["products"] as? [[String: Any]] {
                            products.append(contentsOf: productList)
                        }
                    }
                }
                
                completion(products)
            case .failure(let error):
                print("Hata durumu: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    func getFavorites(completion: @escaping ([[String: Any]]) -> Void) {
        FirebaseManager.instance.fetchCollection(collection: .favorites) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
            switch result {
            case .success(let carts):
                var products: [[String: Any]] = []
                
                for cart in carts {
                    let data = cart.data
                    
                    if let cartsBy = data["favoriBy"] as? String, cartsBy == Auth.auth().currentUser?.email {
                        if let productList = data["favoriList"] as? [[String: Any]] {
                            products.append(contentsOf: productList)
                        }
                    }
                }
                
                completion(products)
            case .failure(let error):
                print("Hata durumu: \(error.localizedDescription)")
                completion([])
            }
        }
    }
    
    func addFavorite(favoriteData: [String: Any], newFavorite: [String: Any]) -> Observable<(Bool, Error?)> {
        
        guard let userId = Auth.auth().currentUser?.email else {
            favorite.value = (false, FirebaseError.userAuth)
            return favorite
        }
        
        DispatchQueue.main.async {
            FirebaseManager.instance.fetchCollection(collection: .favorites) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let favorites):
                    if let userFavorite = favorites.first(where: { $0.data["favoriBy"] as? String == userId }) {
                        let favoriteId = userFavorite.documentID
                        var favoriteList = userFavorite.data["favoriList"] as? [[String: Any]] ?? []
                        
                        let existingProductIndex = favoriteList.firstIndex(where: {
                            $0["productId"] as? Int == favoriteData["productId"] as? Int
                        })
                        
                        if existingProductIndex != nil {
                            // Ürün zaten favori listesinde var
                            self.favorite.value = (false, FirebaseError.docAddFailed)
                        } else {
                            // Ürünü favori listesinde yok
                            favoriteList.append(favoriteData)
                            
                            let favoritesRef = Firestore.firestore().collection(Collections.favorites.rawValue)
                            favoritesRef.document(favoriteId).updateData(["favoriList": favoriteList]) { error in
                                if error != nil {
                                    self.favorite.value = (false, FirebaseError.docUpdateFailed)
                                } else {
                                    self.favorite.value = (true, nil)
                                }
                            }
                        }
                    } else {
                        var updatedFavorite = newFavorite
                        updatedFavorite["favoriList"] = [favoriteData]
                        
                        let favoritesRef = Firestore.firestore().collection(Collections.favorites.rawValue)
                        favoritesRef.addDocument(data: updatedFavorite) { error in
                            if error != nil {
                                self.favorite.value = (false, FirebaseError.docCreationFailed)
                            } else {
                                self.favorite.value = (true, nil)
                            }
                        }
                    }
                case .failure(let error):  //koleksiyone erişemedi
                    self.favorite.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        
        return favorite
    }
    
    func removeFavorite(productId: Int) -> Observable<(Bool, Error?)> {
        
        guard let userId = Auth.auth().currentUser?.email else {
            favorite.value = (false, FirebaseError.userAuth)
            return favorite
        }
        
        DispatchQueue.main.async {
            FirebaseManager.instance.fetchCollection(collection: .favorites) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let favorites):
                    if let userFavorite = favorites.first(where: { $0.data["favoriBy"] as? String == userId }) {
                        let favoriteId = userFavorite.documentID
                        var favoriteList = userFavorite.data["favoriList"] as? [[String: Any]] ?? []
                        
                        if let existingProductIndex = favoriteList.firstIndex(where: {
                            $0["productId"] as? Int == productId
                        }) {
                            favoriteList.remove(at: existingProductIndex)
                            
                            let favoritesRef = Firestore.firestore().collection(Collections.favorites.rawValue)
                            favoritesRef.document(favoriteId).updateData(["favoriList": favoriteList]) { error in
                                if error != nil {
                                    self.favorite.value = (false, FirebaseError.docUpdateFailed)
                                } else {
                                    self.favorite.value = (true, nil)
                                }
                            }
                        } else {
                            // Ürün favori listesinde bulunamadı
                            self.favorite.value = (false, FirebaseError.docNotFound)
                        }
                    } else {
                        // Kullanıcının favori belgesi bulunamadı
                        self.favorite.value = (false, FirebaseError.docNotFound)
                    }
                case .failure(let error):
                    self.favorite.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        return favorite
    }
    
    func removeCart(productId: Int) -> Observable<(Bool, Error?)> {
        
        guard let userId = Auth.auth().currentUser?.email else {
            cart.value = (false, FirebaseError.userAuth)
            return cart
        }
        
        DispatchQueue.main.async {
            FirebaseManager.instance.fetchCollection(collection: .carts) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
                switch result {
                case .success(let carts):
                    if let userCart = carts.first(where: { $0.data["cartsBy"] as? String == userId }) {
                        let cartId = userCart.documentID
                        var products = userCart.data["products"] as? [[String: Any]] ?? []
                        
                        if let existingProductIndex = products.firstIndex(where: {
                            $0["productId"] as? Int == productId
                        }) {
                            products.remove(at: existingProductIndex)
                            
                            let cartRef = Firestore.firestore().collection(Collections.carts.rawValue)
                            cartRef.document(cartId).updateData(["products": products]) { error in
                                if error != nil {
                                    self.cart.value = (false, FirebaseError.docUpdateFailed)
                                } else {
                                    self.cart.value = (true, nil)
                                }
                            }
                        } else {
                            // Ürün sepette bulunamadı
                            self.cart.value = (false, FirebaseError.docNotFound)
                        }
                    } else {
                        // Kullanıcının sepeti bulunamadı
                        self.cart.value = (false, FirebaseError.docNotFound)
                    }
                case .failure(let error):
                    self.cart.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
                }
            }
        }
        return cart
    }
    
    func favListControl(productId: Int) -> Observable<(Bool, Error?)> {
        guard let userId = Auth.auth().currentUser?.email else {
            favorite.value = (false, FirebaseError.userAuth)
            return favorite
        }
        FirebaseManager.instance.fetchCollection(collection: .favorites) { (result: Swift.Result<Array<(documentID: String, data: [String: Any])>, FirebaseError>) in
            switch result {
            case .success(let favorites):
                if let userFavorite = favorites.first(where: { $0.data["favoriBy"] as? String == userId }) {
                    let favoriteList = userFavorite.data["favoriList"] as? [[String: Any]] ?? []
                    
                    let isProductInFavorites = favoriteList.contains(where: { ($0["productId"] as? Int) == productId })
                    
                    if isProductInFavorites {
                        // Ürün favori listesinde
                        self.favorite.value = (true, nil)
                    } else {
                        // Ürün favori listesinde değil
                        self.favorite.value = (false, nil)
                    }
                } else {
                    // Kullanıcının favori belgesi bulunamadı
                    self.favorite.value = (false, FirebaseError.docNotFound)
                }
            case .failure(let error):
                self.favorite.value = (false, FirebaseError.queryFailed(message: error.localizedDescription))
            }
        }
        return favorite
    }
    
}
