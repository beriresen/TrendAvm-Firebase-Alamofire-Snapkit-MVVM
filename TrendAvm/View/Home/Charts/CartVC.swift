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
    var productList: [[String: Any]] = []
    var selectedProduct: String?
    var selectedProductId:Int?
    var selectedProductQuantity:Int?
    var viewModel = ProductsViewModel()
    private var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupTableView()
        setupViewModelObserver()

        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("PriceDecrease"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("PriceIncrease"), object: nil)
        
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Sepetim"
        let headerView = tableView.tableHeaderView!

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.customCell)
      
    }
    
    
     func configure()  {
        self.view.addSubview(tableView)
         
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
         tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let userId = authenticateUser() {
            let productData: [String: Any] = [
                "productId": product.id,
                "productPrice": product.price,
                "totalPrice": product.price,
                "productQuantity": selectedProductQuantity,
                "date": Date()
            ]
            let newCart: [String: Any] = [
                "userId": userId,
                "cartsBy": userId,
                "products": [productData]
            ]
            
            if notification.name == Notification.Name("PriceDecrease") {
                
                viewModel.decreaseQuantity(productData: productData, newCart: newCart)

            }else if notification.name == Notification.Name("PriceIncrease") {
                
                viewModel.increaseQuantity(productData: productData, newCart: newCart)

            }
        }
    }
    
    

    
    fileprivate func setupViewModelObserver() {
        viewModel.getCart { [weak self] (products: [[String: Any]]) in
            self?.productList = products
            self?.tableView.reloadData()
        }
    }
    
    
    func showDeleteConfirmationAlert(indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: "Ürünü sepetten silmek istediğinize emin misiniz?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { [weak self] (_) in
            self?.deleteProduct(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        // Silme işlemini gerçekleştir ve tableView'i güncelle
        // indexPath kullanarak productList'ten ilgili ürünü kaldır
        guard let selectedProductId = selectedProductId else {
              return // selectedProductId değeri boşsa işlem yapma
          }
        viewModel.removeCart(productId: selectedProductId )
        productList.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
}


extension CartVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   productList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.customCell, for: indexPath) as! CartCell
        let product = productList[indexPath.row]
        
        cell.productImage.kf.setImage(with: URL(string: product["productImageURL"] as? String ?? ""))
        cell.lblProductName.text = product["productName"] as? String
        
        if product["productQuantity"]  is String {
            cell.lblProductQuantity.text =  product["productQuantity"] as? String ?? ""
            
        }else {
            if let productQuantity = product["productQuantity"] as? Int {
                cell.lblProductQuantity.text = String(productQuantity)
                //                if productQuantity > 1 {
                //                   cell.minusButton.isEnabled = true
                //                }else {
                //                    cell.minusButton.isEnabled = false
                //                }
            }
        }
        if let productPrice = product["totalPrice"] as? Double {
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
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
               self?.showDeleteConfirmationAlert(indexPath: indexPath)
               completion(true)
           }
           deleteAction.backgroundColor = .red
           
           let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
           swipeConfiguration.performsFirstActionWithFullSwipe = false
           
           return swipeConfiguration
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = productList[indexPath.row]
        selectedProductId = item["productId"] as! Int
        if let selectedProduct = productList.first(where: { $0["productId"] as? Int == selectedProductId }) {  // Seçilen ürünün bilgilerini güncelle
            product.id = selectedProduct["productId"] as? Int
            product.price = selectedProduct["productPrice"] as? Double
            selectedProductQuantity = selectedProduct["productQuantity"] as? Int
        }
        
        
    }
    
    
}
