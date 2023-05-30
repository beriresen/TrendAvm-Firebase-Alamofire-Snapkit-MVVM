//
//  FavoritesVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 9.05.2023.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import Kingfisher
import FirebaseAuth

class FavoritesVC: UIViewController {

    var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    var viewModel = ProductsViewModel()
    var favoritList: [[String: Any]] = []
    var selectedProductId:Int?
    private var product = Product()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        configure()
        setupViewModelObserver()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.title = "Favorilerim"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setupViewModelObserver()

    }
    func setupTableView(){
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.favCustomCell)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
        
    }
    private func configure()  {
        self.view.addSubview(tableView)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: .leastNonzeroMagnitude)) //title tablonun üzerinde boş bir alana sahip olmaz.
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func setupViewModelObserver() {
        if let userId = authenticateUser() {
            viewModel.getFavorites { [weak self] (favoritList: [[String: Any]]) in
                self?.favoritList = favoritList
                self?.tableView.reloadData()
                
            }
        }else {
            self.favoritList = []
                    self.tableView.reloadData()
        }
    }

}
extension FavoritesVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesCell.favCustomCell, for: indexPath) as! FavoritesCell
        let product = favoritList[indexPath.row]
        cell.productImage.kf.setImage(with: URL(string: product["productImageURL"] as? String ?? ""))
        cell.lblProductName.text = product["productName"] as? String
        if let productPrice = product["productPrice"] as? Double {
            let integerPart = Int(productPrice)
            let decimalPart = Int((productPrice - Double(integerPart)) * 100)
            var priceString = ""
            
            if decimalPart == 0 {
                priceString = "\(integerPart)"
            } else {
                priceString = "\(integerPart).\(decimalPart)"
            }
            
            priceString += " TL"
            
            cell.lblProductPrice.text = priceString
        }
        cell.lblProductCategory.text = product["productCategory"] as? String
        cell.lblRate.text = product["productRating"] as? String

        if let productRating = product["productRating"] as? String {

            if let rating = Double(productRating) {
                if rating > 0 {
                    cell.star1.image = UIImage(named: "star_yellow")
                }
                if rating > 1 {
                    cell.star2.image = UIImage(named: "star_yellow")
                }
                if rating > 2 {
                    cell.star3.image = UIImage(named: "star_yellow")
                }
                if rating > 3 {
                    cell.star4.image = UIImage(named: "star_yellow")
                }
                if rating > 4 {
                    cell.star5.image = UIImage(named: "star_yellow")
                }

                cell.lblRate.text = productRating
            } else {
                print("Invalid rating value: \(productRating)")
            }
        }

        cell.lblCount.text = product["productCount"] as? String
        cell.btnSepeteEkle.addTarget(self, action: #selector(sepeteEkle), for: .touchUpInside)
        return cell
    }
    @objc func sepeteEkle(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)     // Butonun konumunu tableView içindeki bir noktaya dönüştürmek için kullanılır
        guard let indexPath = tableView.indexPathForRow(at: point) else { // Dönüştürülen noktaya karşılık gelen indexPath değerini alır
            return
        }

        let product = favoritList[indexPath.row]// Seçilen hücrenin index path'ine göre favori listesinden ilgili ürünü alır
        
        if let userId = authenticateUser() {
            let productData: [String: Any] = [ // Sepete eklemek için gerekli ürün verilerini oluşturur
                "productId": product["productId"] as? Int,
                "productName": product["productName"] as? String,
                "productImageURL": product["productImageURL"] as? String,
                "productCategory": product["productCategory"] as? String,
                "productPrice": product["productPrice"] as? Double,
                "totalPrice": product["productPrice"] as? Double,
                "productQuantity": 1,
                "date": Timestamp(date: Date())
            ]
            
            let newCart: [String: Any] = [
                "userId": userId,
                "cartsBy": userId,
                "products": [productData]
            ]
            
            self.viewModel.addCart(productData: productData, newCart: newCart)
        }
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = favoritList[indexPath.row]      // Seçilen hücrenin verisini al

        if let id = item["productId"] as? Int, // Değerlerin uygun tiplere dönüştürülmesi ve kontrolü
           let title = item["productName"] as? String,
           let price = item["productPrice"] as? Double,
           let description = item["productDescription"] as? String,
           let category = item["productCategory"] as? String,
           let image = item["productImageURL"] as? String,
           let ratingString = item["productRating"] as? String,
           let rating = Double(ratingString),
           let countString = item["productCount"] as? String,
           let count = Int(countString.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)) {

            let ratingObject = Rating(rate: rating, count: count) // Rating nesnesi oluşturma
            let product = Product(id: id, title: title, price: price, description: description, category: category, image: image, rating: ratingObject)// Product nesnesi oluşturma

            let productDetailVC = ProductDetailVC(product: product)
            productDetailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(productDetailVC, animated: true)
        } else {
            print("Invalid product data")
            print("Item: \(item)")
            print("Item type: \(type(of: item))")
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }


}
