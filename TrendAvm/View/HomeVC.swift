//
//  HomeVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 1.03.2023.
//

import UIKit

class HomeVC: UIViewController {
  
    
    
    
    private let lblTitle = UILabel()
    private var homeCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trend Avm"
        view.backgroundColor = .white
        configureLoginVC()
//        setupCollectionView()

       
        
    }

//    //MARK: CollectionView Kurulum işlemleri
//    func setupCollectionView(){
//        homeCollectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: "CollectionCell")
//        homeCollectionView.delegate = self
//        homeCollectionView.dataSource = self
//    }
//    //MARK: Component constraint ayarları
//    func configure(){
//        view.addSubview(homeCollectionView)
//        collectionView.snp.makeConstraints{ (maker) in
//            maker.leading.equalTo(8)
//            maker.trailing.equalTo(-8)
//            maker.edges.equalToSuperview()
//        }
//    }
    
    private func configureLoginVC()  {
        let view = UIView()
        
        view.backgroundColor = .white
        view.addSubview(lblTitle)
        lblTitle.text = "Hello!"
        lblTitle.font = UIFont(name: "Helvetica", size: 22)
        lblTitle.textColor = .darkGray
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(260)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        


    }

    
}


////MARK: CollectionView Ürün listeleme işlemleri Datasource ve Delegate işlemleri
//extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return viewModel.products.value?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell:ProductCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! ProductCollectionViewCell
//
//        let item = viewModel.products.value?[indexPath.row]
//
//        if let item {
//            cell.showData(item: item)
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
//    }
//
//    //Ekranda yatay ve dikey pozisyonda kaç adet view görüntüleneceğini burada ayarlıyoruz
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let gridLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        gridLayout.minimumInteritemSpacing = 0
//        gridLayout.minimumLineSpacing = 0
//        let widthPerItem = collectionView.frame.width / 2
//        let heightPerItem = collectionView.frame.height / 2.5
//        return CGSize(width:widthPerItem, height:heightPerItem)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let item = viewModel.products.value?[indexPath.row]
//
//        if let item {
//            Methods.StartActivity(view: self, viewController: ProductDetailViewController(product: item), isNavigation: false)
//        }
//    }
//}
