//
//  ProductDetailVC.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore


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
    var favButton = UIButton()
    var viewModel = ProductsViewModel()
    
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
        setupViewModelObserver()
        configure()
        navBarConfigure()
        setupViewValue()
    }
    
    //MARK: Setup Components
    func configure(){
        
        view.backgroundColor = .white
        view.addSubview(favButton)
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
        
        
        favButton.backgroundColor = .white
        favButton.layer.cornerRadius = 16
        favButton.layer.shadowColor = UIColor.darkGray.cgColor // Gölge rengi
        favButton.layer.shadowOffset = CGSize(width: 2, height: 2) // Gölgenin yönü
        favButton.layer.shadowOpacity = 0.5 // Gölge yoğunluğu
        favButton.layer.shadowRadius = 2 // Gölgenin keskinliği
        favButton.clipsToBounds = false
        favButton.tintColor = .darkGray
        favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favButton.addTarget(self, action: #selector(favorilereEkle), for: .touchUpInside)
        favButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-8)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
        productImage.layoutIfNeeded()
        productImage.contentMode = .scaleAspectFit
        productImage.clipsToBounds = true
        productImage.snp.makeConstraints{ (make) in
            make.top.equalTo(favButton.snp.bottom).offset(5)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(stackView.snp.top).offset(0)
        }
        
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 4
        stackView.snp.makeConstraints{ (make) in
            make.bottom.equalTo(-40)
            make.trailing.equalTo(0)
            make.leading.equalTo(0)
        }
        
        lblCategory.textColor = UIColor(named:"trendBlue")
        lblCategory.font = UIFont.boldSystemFont(ofSize: 16.0)
        lblCategory.snp.makeConstraints{ (make) in
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
            make.height.equalTo(18)
        }
        
        lblTitle.textColor = .darkGray
        lblTitle.font = UIFont.boldSystemFont(ofSize: 18.0)
        lblTitle.snp.makeConstraints{ (make) in
            make.top.equalTo(lblCategory.snp.bottom).offset(10)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(18)
        }
        
        lblDescription.lineBreakMode = NSLineBreakMode.byWordWrapping
        lblDescription.numberOfLines = 2
        lblDescription.textColor = .darkGray
        lblDescription.font = UIFont(name: "Helvetica", size: 14)
        lblDescription.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.height.equalTo(54)
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
        btnSepeteEkle.layer.borderColor = UIColor(named:"trendDarkOrange")?.cgColor
        btnSepeteEkle.setTitle("Sepete Ekle", for: UIControl.State.normal)
        btnSepeteEkle.addTarget(self, action: #selector(sepeteEkle), for: .touchUpInside)
        btnSepeteEkle.sizeToFit()
        btnSepeteEkle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func navBarConfigure(){
        
        let backButton = UIBarButtonItem(title: "Geri", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        let cartBarButton = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(sepetimTapped))
        let shareBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(sepetimTapped))
        cartBarButton.tintColor = UIColor.black
        shareBarButton.tintColor = UIColor.black

        navigationItem.rightBarButtonItems = [shareBarButton,cartBarButton]

        UIStackView.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).spacing = -10 //iki rightbar arasındaki boşluğu azaltır
    }
    
    @objc  func sepetimTapped(sender:UIButton){
                self.pushCartVC()
    }
    
    @objc  func favorilereEkle(sender:UIButton){
        if let userId = authenticateUser() {
            
            let favoriteData: [String: Any] = [
                "productId": self.product.id,
                "productRating" : self.product.rating?.rate?.description,
                "productCount": self.product.rating?.count?.getCountProduct(),
                "productCategory": self.product.category,
                "productName": self.product.title,
                "productImageURL": self.product.image,
                "productPrice": self.product.price,
                "productDescription": self.product.description,
            ]
            let newFavorite: [String: Any] = [
                "userId": userId,
                "favoriBy": userId,
                "favoriList": [favoriteData]
            ]
           
            if sender.tintColor == UIColor.darkGray {
                sender.tintColor = UIColor(named:"trendOrange")
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
                self.viewModel.addFavorite(favoriteData: favoriteData, newFavorite: newFavorite)
                
            }else {
                sender.tintColor = UIColor.darkGray
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
                
                self.viewModel.removeFavorite(productId: product.id ?? 0)
            }
        }
    }

    @objc  func sepeteEkle(sender:UIButton){
        if let userId = authenticateUser() {
               let productData: [String: Any] = [
                "productId": self.product.id,
                "productName": self.product.title,
                "productImageURL": self.product.image,
                "productCategory": self.product.category,
                "productPrice": self.product.price,
                "totalPrice": self.product.price,
                "productQuantity": 1,
                "date": Timestamp(date: Date())
            ]
            let newCart: [String: Any] = [
                "userId": userId,
                "cartsBy": userId,
                "products": [productData]
            ]
            self.viewModel.addCart(productData: productData, newCart: newCart)
            NotificationCenter.default.post(name: Notification.Name("BadgeUpdated"), object: nil, userInfo: ["action": "plus"])

        }
    }
    
    fileprivate func setupViewModelObserver() {
        viewModel.cart.bind {  [weak self] (cart) in
            DispatchQueue.main.async {
                //                self?.makeAlert(title: "Başarılı", message: "Ürün sepete eklendi.")
                self?.pushCartVC()
            }
        }
        viewModel.favorite.bind {  [weak self] (favorite) in
            DispatchQueue.main.async {
                self?.makeAlert(title: "Başarılı", message: "Ürün favorilere eklendi.")
                //                self?.pushCartVC()
                
            }
        }

      viewModel.favListControl(productId: product.id ?? 0).bind { [weak self] favorite in
            DispatchQueue.main.async {
                if let result = favorite {
                    let isSuccess = result.0
                    let error = result.1

                    if isSuccess {//"Ürün favori listesinde
                        self?.favButtonOrange()
                    } else {
                        if let error = error {
                            print("Hata: \(error)")
                        } else { // "Ürün favori listesinde değil
                            self?.favButtonGray()
                        }
                    }
                }
            }
        }
    }
    func favButtonOrange(){
       favButton.tintColor = UIColor(named:"trendOrange")
       favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    func favButtonGray(){
        favButton.tintColor = .darkGray
        favButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
