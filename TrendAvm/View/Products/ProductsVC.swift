//
//  ProductsVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 6.03.2023.
//

import UIKit
import SnapKit

class ProductsVC: UIViewController {
    
    var viewModel = ProductsViewModel()
    private let collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Trend AVM"
        setupCollectionView()
        configure()
        setupViewModelObserver()
        
        viewModel.getProducts()
    }
    
    //MARK: Component constraint ayarları
    func configure(){
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.edges.equalToSuperview()
        }
    }
    //MARK: CollectionView Kurulum işlemleri
    func setupCollectionView(){
        collectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
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
                let alert = UIAlertController(title: self?.viewModel.alertItem.value?.title ?? "Uyarı",
                                              message: self?.viewModel.alertItem.value?.message ?? "Bir Hata Oluştu",
                                              preferredStyle: .alert)
                let okButton = UIAlertAction(title: self?.viewModel.alertItem.value?.dismissButton ?? "Tamam", style: .default)
                alert.addAction(okButton)
                self?.present(alert, animated: true)
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
        let cell:ProductsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ProductsCollectionViewCell
        
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
            let homeVC = ProductDetailVC(product: item)
            self.navigationController?.pushViewController(homeVC, animated: true)        }
    }
}
