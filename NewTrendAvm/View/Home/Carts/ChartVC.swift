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
import MBProgressHUD

class CartVC: UIViewController{
    
    var itemCount = 0
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
    var productList: [[String: Any]] = []
    var selectedProduct: String?
    var selectedProductId:Int?
    var selectedProductQuantity:Int?
    var viewModel = ProductsViewModel()
    var product = Product()
    var quantityUpdateHandler: ((Int) -> Void)?
    var progressBar: UIProgressView!
    var stackKart = UIStackView()
    var lblTotal = UILabel()
    var lblKargo = UILabel()
    var lblTotalPrice = UILabel()
    var btnSepetiOnayla = UIButton()
    var totalPriceSum: Double = 0.0
    var formattedTotalPrice = ""
    var totalStackView = UIStackView()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupTableView()
        setupViewModelObserver()
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
        
        self.view.addSubview(stackKart)
        totalStackView.addArrangedSubview(lblTotal)
        totalStackView.addArrangedSubview(lblTotalPrice)
        totalStackView.addArrangedSubview(lblKargo)
        stackKart.addArrangedSubview(totalStackView)
        stackKart.addArrangedSubview(btnSepetiOnayla)
        
        stackKart.axis = .horizontal
        stackKart.distribution  = UIStackView.Distribution.fillEqually
        stackKart.alignment = UIStackView.Alignment.center
        stackKart.spacing   = 8
        stackKart.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8) // En altta olmasını sağlar
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.height.equalTo(48)
        }
        
        totalStackView.axis = .vertical
        totalStackView.alignment = .leading
        totalStackView.spacing = 4
        
        lblTotal.font = UIFont.systemFont(ofSize: 11.0)
        lblTotal.textColor = .darkGray
        lblTotal.text = "Toplam"
        
        lblTotalPrice.font = UIFont.systemFont(ofSize: 14.0)
        lblTotalPrice.textColor = .black
        
        lblKargo.font = UIFont.systemFont(ofSize: 11.0)
        lblKargo.text = "Kargo Bedava"
        lblKargo.textColor = UIColor(named:"darkGreen")

        
        btnSepetiOnayla.backgroundColor = UIColor(named:"trendOrange")
        btnSepetiOnayla.layer.cornerRadius = 4
        btnSepetiOnayla.layer.borderColor = UIColor(named:"trendDarkOrange")?.cgColor
        btnSepetiOnayla.setTitle("Sepeti Onayla", for: UIControl.State.normal)
        btnSepetiOnayla.sizeToFit()
        btnSepetiOnayla.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func totalPrice(){
        // totalPrice alanlarının toplamını hesapla
        for product in productList {
            if let productPrice = product["totalPrice"] as? Double {
                totalPriceSum += productPrice
            }
        }

        // Toplam fiyatı lblTotale yazdır
        if totalPriceSum.truncatingRemainder(dividingBy: 1) != 0 {
            formattedTotalPrice = String(format: "%.2f", totalPriceSum)
            print("total\(formattedTotalPrice)")
        } else {
            formattedTotalPrice = String(format: "%.0f", totalPriceSum)
            print("total\(formattedTotalPrice)")

        }
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
                self?.totalPrice()

                self?.lblTotalPrice.text = self!.formattedTotalPrice + " TL"

            }
        }else {
            self.productList = []
            self.tableView.reloadData()
            totalPrice()

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
        NotificationCenter.default.post(name: Notification.Name("BadgeUpdated"), object: nil, userInfo: ["action": "minus"])

    }
    
}


extension CartVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   productList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.customCell, for: indexPath) as! CartCell
        cell.selectionStyle = .none

        let product = productList[indexPath.row]
        
        cell.productImage.kf.setImage(with: URL(string: product["productImageURL"] as? String ?? ""))
        cell.lblProductName.text = product["productName"] as? String
        if product["productQuantity"]  is String {
            cell.lblProductQuantity.text =  product["productQuantity"] as? String ?? ""
            
        } else {
            if let productQuantity = product["productQuantity"] as? Int {
                cell.lblProductQuantity.text = String(productQuantity)
            }
        }

        if let productPrice = product["totalPrice"] as? Double {
            let formattedPrice: String
            if productPrice.truncatingRemainder(dividingBy: 1) != 0 {
                formattedPrice = String(format: "%.2f", productPrice)
            } else {
                formattedPrice = String(format: "%.0f", productPrice)
            }
            cell.lblProductPrice.text = "\(formattedPrice) TL"
            
            cell.plusButton.tag = indexPath.row
            cell.plusButton.addTarget(self, action: #selector(increaseCounter(_:)), for: .touchUpInside)
            
            cell.minusButton.tag = indexPath.row
            cell.minusButton.addTarget(self, action: #selector(decreaseCounter(_:)), for: .touchUpInside)
        }
        
        return cell
    }

    @objc func increaseCounter(_ sender: UIButton) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)

        if let userId = authenticateUser() {
            let indexPath = IndexPath(row: sender.tag, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? CartCell {
                if let currentQuantity = Int(cell.lblProductQuantity.text ?? "") {
                    let newQuantity = currentQuantity + 1
                    cell.lblProductQuantity.text = "\(newQuantity)"
                    
                    if let currentPriceString = cell.lblProductPrice.text,
                       let currentPrice = Double(currentPriceString.replacingOccurrences(of: " TL", with: "")),
                       let totalPrice = productList[indexPath.row]["totalPrice"] as? Double {
                        let newPrice = currentPrice + totalPrice
                        
                        let formattedPrice: String
                        if newPrice.truncatingRemainder(dividingBy: 1) != 0 {
                            formattedPrice = String(format: "%.2f TL", newPrice)
                        } else {
                            formattedPrice = String(format: "%.0f TL", newPrice)
                        }
                        
                        cell.lblProductPrice.text = formattedPrice
                        
                        let productData: [String: Any] = [
                            "productId": selectedProductId,
                            "totalPrice": formattedPrice,
                            "productPrice": product.price,
                            "productQuantity": cell.lblProductQuantity.text,
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
        progressHUD.hide(animated: true)

    }

    @objc func decreaseCounter(_ sender: UIButton) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)

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
                        
                        let formattedPrice: String
                        if newQuantity < 1 {
                            formattedPrice = "0 TL"
                        } else if newPrice < 0 {
                            formattedPrice = "0 TL"
                        } else if newPrice.truncatingRemainder(dividingBy: 1) != 0 {
                            formattedPrice = String(format: "%.2f TL", newPrice)
                        } else {
                            formattedPrice = String(format: "%.0f TL", newPrice)
                        }
                        
                        cell.lblProductPrice.text = formattedPrice
                        
                        let productData: [String: Any] = [
                            "productId": selectedProductId,
                            "totalPrice": formattedPrice,
                            "productPrice": product.price,
                            "productQuantity": cell.lblProductQuantity.text,
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
        progressHUD.hide(animated: true)

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
