//
//  ProductsVCUnitTests.swift
//  NewTrendAvmTests
//
//  Created by Berire Şen Ayvaz on 14.06.2023.
//

import XCTest
@testable import NewTrendAvm

final class ProductsVCUnitTests: XCTestCase {
    var productsVC =  ProductsVC()


    override func setUp() {
           super.setUp()
           productsVC = ProductsVC()
           // Gerekli hazırlıklar yapılabilir
       }
    func testCollectionViewDataSource() {
          // CollectionView'nin dataSource'i doğru şekilde ayarlanmış mı?
        let items = [Product(), Product(), Product()]
         
         // ProductsVC örneğini oluşturun
         let productsVC = ProductsVC()
         
         // CollectionView'ı oluşturun
         let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
         
         // CollectionView'a ProductsVC'yi dataSource olarak atayın
         collectionView.dataSource = productsVC
         
         // CollectionView'a hücre sınıfını ve yeniden kullanılabilir kimliği kaydedin
         collectionView.register(ProductsCollectionVC.self, forCellWithReuseIdentifier: "CollectionCell")
         
         // ProductsVC'nin viewModel.products değerine test verilerini atayın
         productsVC.viewModel.products.value = items
         
         // CollectionView'daki veri kaynaklarına erişin ve eleman sayısını kontrol edin
         let numberOfItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0)
         
         XCTAssertEqual(numberOfItems, items.count)
      }
    func testCollectionViewDelegate() {
        let productsVC = ProductsVC()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 320, height: 480), collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.delegate = productsVC
        
        // Örnek Product nesneleri
        let product1 = Product(id: 1, title: "Solid Gold Petite ", price: 168, description: "21.5 inches Full HD", category: "electronics", image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg", rating: Rating(rate: 1.9, count: 250))
        let product2 = Product(id: 2, title: "Solid Gold Petite Micropave", price: 18, description: "21.5 inches Full HD", category: "electronics", image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg", rating: Rating(rate: 2.9, count: 150))
        let product3 = Product(id: 3, title: "Solid Gold Petite ", price: 18, description: "21.5 inches Full HD", category: "electronics", image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg", rating: Rating(rate: 2.9, count: 150))
        let product4 = Product(id: 4, title: "Solid Gold Petite ", price: 18, description: "21.5 inches Full HD", category: "electronics", image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg", rating: Rating(rate: 2.9, count: 150))
        let product5 = Product(id: 5, title: "Solid Gold Petite ", price: 18, description: "21.5 inches Full HD", category: "electronics", image: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg", rating: Rating(rate: 2.9, count: 150))
        
        // ProductsVC'nin products değerini ayarlayın
        productsVC.viewModel.products.value = [product1, product2, product3, product4, product5]
        
        // CollectionView'deki delegate'nin ProductsVC olduğunu doğrula
        XCTAssertTrue(collectionView.delegate === productsVC)
        
        // CollectionView'e öğeleri ekle
        collectionView.reloadData()
        
        // Öğeler yüklendikten sonra CollectionView'deki seçili öğenin product2 olduğunu doğrula
        collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .centeredVertically)
        let selectedProduct = productsVC.viewModel.products.value?[1]
        XCTAssertTrue(selectedProduct != nil && selectedProduct!.id == product2.id)
    }



}
