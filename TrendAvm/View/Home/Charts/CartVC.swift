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
    var quantityUpdateHandler: ((Int) -> Void)?

    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupTableView()
        setupViewModelObserver()

    }
    @objc func updateBadge() {
        // badge değerini güncelle
        // Örneğin, badgeLabel.text = "\(badge)"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Sepetim"
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.customCell)
        
    }
    
    
    func configure()  {
        self.view.addSubview(tableView)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: .leastNonzeroMagnitude))
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        //         tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
    }
    

    
    func updateCell(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CartCell {
            // Hücreyi güncelleyin
            // Örneğin:
            cell.lblProductQuantity.text = "\(selectedProductQuantity)"
        }
    }

    fileprivate func setupViewModelObserver() {

        if let userId = authenticateUser() {
            viewModel.getCart { [weak self] (products: [[String: Any]]) in
                self?.productList = products
                self?.tableView.reloadData()
            }
        }else {
            self.productList = []
            self.tableView.reloadData()
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
            let formattedPrice = String(format: "%.2f", productPrice)
            cell.lblProductPrice.text = "\(formattedPrice) TL"
            
            cell.plusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(increaseCounter(_:)), for: .touchUpInside)
            
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(decreaseCounter(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    @objc func increaseCounter(_ sender: UIButton) {
        if let userId = authenticateUser() {
            print("iddd \(selectedProductId)")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? CartCell {
                if let currentQuantity = Int(cell.lblProductQuantity.text ?? "") {
                    let newQuantity = currentQuantity + 1
                    cell.lblProductQuantity.text = "\(newQuantity)"
                    
                    if let currentPriceString = cell.lblProductPrice.text,
                       let currentPrice = Double(currentPriceString.replacingOccurrences(of: " TL", with: "")),
                       let totalPrice = productList[indexPath.row]["totalPrice"] as? Double {
                        let newPrice = currentPrice + totalPrice
                        cell.lblProductPrice.text = String(format: "%.2f TL", newPrice)
                        
                        let productData: [String: Any] = [
                            "productId": selectedProductId,
                            "totalPrice": cell.lblProductPrice.text,
                            "productPrice": product.price,
                            "productQuantity":  cell.lblProductQuantity.text,
                            "date": Date()
                        ]
                        let newCart: [String: Any] = [
                            "userId": userId,
                            "cartsBy": userId,
                            "products": [productData]
                        ]
                        viewModel.increaseQuantity(productData: productData, newCart: newCart)
                        NotificationCenter.default.post(name: Notification.Name("BadgeUpdated"), object: nil, userInfo: ["action": "plus"])

                    }
                }
            }
        }
    }
    @objc func decreaseCounter(_ sender: UIButton) {
        if let userId = authenticateUser() {
            
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? CartCell {
                if let currentQuantity = Int(cell.lblProductQuantity.text ?? ""), currentQuantity > 1 {
                    let newQuantity = currentQuantity - 1
                    cell.lblProductQuantity.text = "\(newQuantity)"
                    
                    if let currentPriceString = cell.lblProductPrice.text,
                       let currentPrice = Double(currentPriceString.replacingOccurrences(of: " TL", with: "")),
                       let totalPrice = productList[indexPath.row]["totalPrice"] as? Double {
                        let newPrice = currentPrice - totalPrice
                        cell.lblProductPrice.text = String(format: "%.2f TL", newPrice)
                        let productData: [String: Any] = [
                            "productId": selectedProductId,
                            "totalPrice": cell.lblProductPrice.text,
                            "productPrice": product.price,
                            "productQuantity":  cell.lblProductQuantity.text,
                            "date": Date()
                        ]
                        let newCart: [String: Any] = [
                            "userId": userId,
                            "cartsBy": userId,
                            "products": [productData]
                        ]
                        viewModel.decreaseQuantity(productData: productData, newCart: newCart)
                        NotificationCenter.default.post(name: Notification.Name("BadgeUpdated"), object: nil, userInfo: ["action": "minus"])

                    }
                } else {
                    // Show confirmation alert
               showDeleteConfirmationAlert(indexPath: indexPath)
                }
            }
        }
    }


//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
//            self?.showDeleteConfirmationAlert(indexPath: indexPath)
//            completion(true)
//        }
//        deleteAction.backgroundColor = .red
//
//        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
//        swipeConfiguration.performsFirstActionWithFullSwipe = false
//
//        return swipeConfiguration
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
