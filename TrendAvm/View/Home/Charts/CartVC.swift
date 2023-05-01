//
//  ChartVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//
import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import Kingfisher
import FirebaseAuth

class CartVC: UIViewController{
     var itemCount = 0
     var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
     var selectedProduct: String?
     var productList: [[String: Any]] = []
     var selectedProductId:Int?
     override func viewDidLoad() {
          super.viewDidLoad()
          
          
          tableView.layoutMargins = UIEdgeInsets.zero
          tableView.separatorInset = UIEdgeInsets.zero
          configure()
          setupTableView()
          NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("PriceDecrease"), object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("PriceIncrease"), object: nil)
          getProduct()
     }
     init() {
          super.init(nibName: nil, bundle: nil)
          self.title = "Sepetim"
          
     }
     @objc func handleNotification(_ notification: Notification) {
          if notification.name == Notification.Name("PriceDecrease") {
               print("azalt")
               
               // Firestore referansı
               let db = Firestore.firestore()
               
               // carts koleksiyonu referansı ve "@gmail.com" kullanıcısının belgesi
               let cartsRef = db.collection("carts")
               let userCartRef = cartsRef.whereField("userId", isEqualTo: Auth.auth().currentUser?.email)
               print("brrr\(selectedProductId)")
               // Kullanıcının sepetindeki belgeleri alın
               
               userCartRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                         print("Error getting documents: \(error.localizedDescription)")
                    } else {
                         for document in querySnapshot!.documents {
                              var updatedProductsArray = [[String: Any]]()
                              if let productsArray = document.data()["products"] as? [[String: Any]] {
                                   for product in productsArray {
                                        var updatedProduct = product
                                        let currentProductId = product["productId"] as! Int
                                        if currentProductId == self.selectedProductId {
                                             var currentQuantity = product["productQuantity"] as! Int
                                             currentQuantity -= 1
                                             if currentQuantity > 0 {
                                                  updatedProduct["productQuantity"] = currentQuantity
                                             } else {
                                                  continue
                                             }
                                        }
                                        updatedProductsArray.append(updatedProduct)
                                   }
                              }
                              let updatedData: [String: Any] = ["products": updatedProductsArray]
                              let docRef = cartsRef.document(document.documentID)
                              docRef.updateData(updatedData) { (error) in
                                   if let error = error {
                                        print("Ürün güncellenemedi: \(error.localizedDescription)")
                                   } else {
                                        print("Ürün güncelleme başarılı")
                                        self.getProduct()
                                   }
                              }
                         }
                    }
               }
          }else if notification.name == Notification.Name("PriceIncrease") {
               print("artır")
                     let db = Firestore.firestore()
               
               // carts koleksiyonu referansı ve "@gmail.com" kullanıcısının belgesi
               let cartsRef = db.collection("carts")
               let userCartRef = cartsRef.whereField("userId", isEqualTo: Auth.auth().currentUser?.email )
               
               // Kullanıcının sepetindeki belgeleri alın
               userCartRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                         print("Error getting documents: \(error.localizedDescription)")
                    } else {
                         for document in querySnapshot!.documents {
                              let productsArray = document.data()["products"] as! [[String: Any]]
                              var updatedProductsArray = [[String: Any]]()
                              for product in productsArray {
                                   var updatedProduct = product
                                   let productId = product["productId"] as! Int
                                   if productId == productId {
                                        let currentQuantity = product["productQuantity"] as! Int
                                        updatedProduct["productQuantity"] = currentQuantity + 1
                                   }
                                   updatedProductsArray.append(updatedProduct)
                              }
                              let updatedData: [String: Any] = ["products": updatedProductsArray]
                              let docRef = cartsRef.document(document.documentID)
                              docRef.updateData(updatedData) { (error) in
                                   if let error = error {
                                        print("Ürün güncellenemedi: \(error.localizedDescription)")
                                   } else {
                                        print("Ürün güncelleme başarılı")
                                        self.getProduct()
                                   }
                              }
                         }
                    }
               }
          }
          
     }
     
     required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
     }
     
     func setupTableView(){
          tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.customCell)
          tableView.delegate = self
          tableView.dataSource = self
     }
     
     
     private func configure()  {
          self.view.addSubview(tableView)
          tableView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
          }
     }
     
     func getProduct(){
          let firestoreDatabase = Firestore.firestore()
          let chartsBy = Auth.auth().currentUser?.email
          let cartsRef = firestoreDatabase.collection("carts")
          cartsRef.whereField("chartsBy", isEqualTo: chartsBy).getDocuments { (snapshot, error) in
               if let error = error {
                    print("Error getting documents: \(error)")
                    return
               }
               
               guard let snapshot = snapshot else {
                    print("Error: Snapshot is nil")
                    return
               }
               
               var products: [[String: Any]] = []
               for document in snapshot.documents {
                    let chartData = document.data()
                    let userId = chartData["userId"] as? String ?? ""
                    let chartsBy = chartData["chartsBy"] as? String ?? ""
                    let chartProducts = chartData["products"] as? [[String: Any]] ?? []
                    products.append(contentsOf: chartProducts)
               }
               
               self.productList = products
               self.tableView.reloadData()
          }
     }
     
}
extension CartVC:UITableViewDelegate,UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return  productList.count
     }
     
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.customCell, for: indexPath) as! CartCell
          let product = productList[indexPath.row]
          
          cell.productImage.kf.setImage(with: URL(string: product["productImageURL"] as? String ?? ""))
          cell.lblProductName.text = product["productName"] as? String
          cell.lblProductPrice.text = "$\(product["productPrice"] as! Double)"
          
          if product["productQuantity"]  is String {
               cell.lblProductQuantity.text =  product["productQuantity"] as? String ?? ""
               
          }else {
               if let productQuantity = product["productQuantity"] as? Int {
                    cell.lblProductQuantity.text = String(productQuantity)
               }
          }
          if let productPrice = product["productPrice"] as? Double {
               let integerPart = Int(productPrice)
               let decimalPart = Int((productPrice - Double(integerPart)) * 100)
               
               if decimalPart == 0 {
                    cell.lblProductPrice.text = "\(integerPart)"
               } else {
                    cell.lblProductPrice.text = "\(integerPart).\(decimalPart)"
               }
          }
          return cell
     }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 90
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
          let item = productList[indexPath.row]
          selectedProductId = item["productId"] as! Int
          
          print(selectedProductId)
     }
     
}
