//
//  ChartVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//

import UIKit
import SnapKit

class ChartVC: UIViewController{
  
    var viewModel = ProductsViewModel()

    var lblChart = UILabel()
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
   
    var kCellIdentifier = "CellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupTableView()

        configure()
    }
    func setupTableView(){
        tableView.register(ChartTVC.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configure()  {
        view.addSubview(lblChart)
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.edges.equalToSuperview()
        }
    }

}


extension ChartVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ChartTVC = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)! as! ChartTVC
                
                cell.textLabel?.text = "a"
                
                return cell
    }
    
    
}
