//
//  ProductDetailVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseStorage
import FirebaseAuth


class ProductDetailVC: UIViewController {
    
    //Components
    var productImage = UIImageView()
    var stackView = UIStackView()
    var lblCategory = UILabel()
    var lblTitle = UILabel()
    var lblDescription = UILabel()
    var lblRate = UILabel()
    var lblCount = UILabel()
    var lblPrice = UILabel()
    var viewPoint = UIView()
    var stackKart = UIStackView()
    var star1 = UIImageView()
    var star2 = UIImageView()
    var star3 = UIImageView()
    var star4 = UIImageView()
    var star5 = UIImageView()
    var btnSepeteEkle = UIButton()
    var uuid = UUID().uuidString
    
    //Objects
    private var product = Product()
    
    //inits
    init(product: Product) {
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupViewValue()
        let backButton = UIBarButtonItem(title: "Geri", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        let rightBarButton = UIBarButtonItem(title: "Sepetim", style: .plain, target: self, action: #selector(sepetimTapped))
        rightBarButton.tintColor = UIColor(named:"trendOrange")
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    //MARK: Setup Components
    func configure(){
        
        
        view.backgroundColor = .white
        
        view.addSubview(productImage)
        view.addSubview(stackView)
        stackView.addArrangedSubview(lblCategory)
        stackView.addArrangedSubview(lblTitle)
        stackView.addArrangedSubview(lblDescription)
        stackView.addArrangedSubview(viewPoint)
        viewPoint.addSubview(lblRate)
        viewPoint.addSubview(star1)
        viewPoint.addSubview(star2)
        viewPoint.addSubview(star3)
        viewPoint.addSubview(star4)
        viewPoint.addSubview(star5)
        viewPoint.addSubview(lblCount)
        stackView.addArrangedSubview(stackKart)
        stackKart.addArrangedSubview(lblPrice)
        stackKart.addArrangedSubview(btnSepeteEkle)
        
        productImage.layoutIfNeeded()
        productImage.contentMode = .scaleAspectFit
        productImage.clipsToBounds = true
        productImage.snp.makeConstraints{ (maker) in
            maker.top.equalTo(8)
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.bottom.equalTo(stackView.snp.top).offset(0)
        }
        
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 4
        stackView.snp.makeConstraints{ (make) in
            make.bottom.equalTo(-40)
            make.trailing.equalTo(0)
            make.leading.equalTo(0)
        }
        
        lblCategory.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblCategory.snp.makeConstraints{ (make) in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
            make.height.equalTo(18)
        }
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        lblTitle.snp.makeConstraints{ (make) in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(18)
        }
        
        lblDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblDescription.numberOfLines = 2
        lblDescription.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.height.equalTo(64)
        }
        
        viewPoint.snp.makeConstraints { (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
        }
        
        lblRate.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.centerY.equalToSuperview()
        }
        
        star1.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(lblRate.snp.trailing).offset(8)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.centerY.equalToSuperview()
        }
        
        star2.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star1.snp.trailing).offset(4)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.centerY.equalToSuperview()
        }
        
        star3.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star2.snp.trailing).offset(4)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.centerY.equalToSuperview()
        }
        
        star4.snp.makeConstraints{ (make) in
            make.leading.equalTo(star3.snp.trailing).offset(4)
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        star5.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star4.snp.trailing).offset(4)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.centerY.equalToSuperview()
            
        }
        
        lblCount.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star5.snp.trailing).offset(8)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.centerY.equalToSuperview()
        }
        
        
        stackKart.axis = .horizontal
        stackKart.distribution  = UIStackView.Distribution.fillEqually
        stackKart.alignment = UIStackView.Alignment.center
        stackKart.spacing   = 8
        stackKart.snp.makeConstraints { (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.height.equalTo(48)
        }
        
        
        lblPrice.font = UIFont.boldSystemFont(ofSize: 18.0)
        lblPrice.textColor = .red
        
        btnSepeteEkle.backgroundColor = UIColor(named:"trendOrange")
        btnSepeteEkle.layer.cornerRadius = 4
        btnSepeteEkle.setTitle("Sepete Ekle", for: UIControl.State.normal)
        btnSepeteEkle.addTarget(self, action: #selector(sepeteEkle), for: .touchUpInside)
        btnSepeteEkle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    @objc  func sepetimTapped(sender:UIButton){
        let cartVC = CartVC()
        self.navigationController?.pushViewController(cartVC, animated: true)
        
    }
    @objc  func sepeteEkle(sender:UIButton){
        let firestoreDatabase = Firestore.firestore()
        let cartsRef = firestoreDatabase.collection("carts")
//        let chartsBy = UserSingleton.userInfo.email
        let chartsBy = Auth.auth().currentUser?.email

        let cartData = [
            "userId":chartsBy,
            "chartsBy": chartsBy,
        ] as [String : Any]

        let productData = [
            "productId": self.product.id,
            "productName": self.product.title,
            "productImageURL": self.product.image,
            "productPrice": self.product.price,
            "productQuantity": 1,
            "date": Date()
        ] as [String : Any]

        cartsRef.whereField("chartsBy", isEqualTo: chartsBy).getDocuments { (snapshot, error) in
            if let error = error {
                self.makeAlert(title: "Error!", message: error.localizedDescription)
                return
            }

            if let documents = snapshot?.documents, !documents.isEmpty {
                // Sepet zaten var, ürünü ekleyin.
                guard let chartDocument = documents.first else {
                    return
                }
                let chartReference = cartsRef.document(chartDocument.documentID)
                chartReference.updateData(["products": FieldValue.arrayUnion([productData])]) { (error) in
                    if let error = error {
                        self.makeAlert(title: "Error!", message: error.localizedDescription)
                    } else {
                        self.makeAlert(title: "Başarılı", message: "Ürün sepete eklendi.")
                        let chartVC = CartVC()
                        self.navigationController?.pushViewController(chartVC, animated: true)
                    }
                }
            } else {
                // Sepet yok, yeni bir tane oluşturun.
                let newCartReference = cartsRef.document()
                newCartReference.setData(cartData) { (error) in
                    if let error = error {
                        self.makeAlert(title: "Error!", message: error.localizedDescription)
                    } else {
                        newCartReference.updateData(["products": [productData]]) { (error) in
                            if let error = error {
                                self.makeAlert(title: "Error!", message: error.localizedDescription)
                            } else {
                                self.makeAlert(title: "Başarılı", message: "Ürün sepete eklendi.")
                                let chartVC = CartVC()
                                self.navigationController?.pushViewController(chartVC, animated: true)
                            }
                        }
                    }
                }
            }
        }


        
    }
    
    
    //MARK: Set value
    func setupViewValue(){
        lblPrice.text = product.price?.getPriceFormat()
        lblCount.text = product.rating?.count?.getCountProductDetail()
        lblRate.text = product.rating?.rate?.description
        lblDescription.text = product.description
        lblTitle.text = product.title
        lblCategory.text = product.category
        productImage.kf.setImage(with: URL(string: product.image ?? ""))
        
        star1.image = UIImage(named: "star_gray")
        star2.image = UIImage(named: "star_gray")
        star3.image = UIImage(named: "star_gray")
        star4.image = UIImage(named: "star_gray")
        star5.image = UIImage(named: "star_gray")
        
        if product.rating?.rate ?? 0 > 0 {
            star1.image = UIImage(named: "star_yellow")
        }
        if product.rating?.rate ?? 0 > 1 {
            star2.image = UIImage(named: "star_yellow")
        }
        if product.rating?.rate ?? 0 > 2 {
            star3.image = UIImage(named: "star_yellow")
        }
        if product.rating?.rate ?? 0 > 3 {
            star4.image = UIImage(named: "star_yellow")
        }
        if product.rating?.rate ?? 0 > 4 {
            star5.image = UIImage(named: "star_yellow")
        }
    }
}
