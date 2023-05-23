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
    func setupTableView(){
        tableView.register(FavoritesCell.self, forCellReuseIdentifier: FavoritesCell.favCustomCell)
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 100
        
    }
    private func configure()  {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    fileprivate func setupViewModelObserver() {
        viewModel.getFavorites { [weak self] (favoritList: [[String: Any]]) in
               self?.favoritList = favoritList
               self?.tableView.reloadData()
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
