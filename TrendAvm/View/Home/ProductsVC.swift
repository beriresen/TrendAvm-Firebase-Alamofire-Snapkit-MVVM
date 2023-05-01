//
//  HomeVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 17.03.2023.
//

import UIKit

class ProductsVC: UIViewController {
    
    var viewModel = ProductsViewModel()
    var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        configure()
        setupViewModelObserver()
        
        viewModel.getProducts()
        title = "Ürünler"
    }
    
    
    //MARK: Component constraint ayarları
    func configure(){
        view.addSubview(collectionView)
      //  view.addSubview(tabbar)
        collectionView.snp.makeConstraints{ (maker) in
            maker.top.equalToSuperview()
                maker.leading.equalTo(0)
                maker.bottom.equalToSuperview()
                maker.trailing.equalTo(view.snp.trailing).offset(0)
        }
        
    }
    //MARK: CollectionView Kurulum işlemleri
    func setupCollectionView(){
        collectionView.register(ProductsCollectionVC.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    //MARK: - ViewModel ve Data Binding işlemleri
    fileprivate func setupViewModelObserver() {
        
        viewModel.products.bind{ [weak self] (alert) in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.alertItem.bind{ [weak self] (alert) in
            DispatchQueue.main.async {
                self?.makeAlert(title: "Uyarı", message: "Bir Hata Oluştu")
            }
        }
    }
    
    
}
//MARK: CollectionView Ürün listeleme işlemleri Datasource ve Delegate işlemleri
extension ProductsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProductsCollectionVC = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ProductsCollectionVC
        
        let item = viewModel.products.value?[indexPath.row]
        
        if let item {
            cell.showData(item: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    //Ekranda yatay ve dikey pozisyonda kaç adet view görüntüleneceğini burada ayarlıyoruz
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
        gridLayout.minimumInteritemSpacing = 0
        gridLayout.minimumLineSpacing = 0
        let widthPerItem = collectionView.frame.width / 2
        let heightPerItem = collectionView.frame.height / 2.5
        return CGSize(width:widthPerItem, height:heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.products.value?[indexPath.row]
        
        if let item {
            let productDetailVC = ProductDetailVC(product: item)
            productDetailVC.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(productDetailVC, animated: true)
            
        }
    }
}

