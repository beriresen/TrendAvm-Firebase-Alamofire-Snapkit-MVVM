//
//  LabelVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 3.05.2023.
//

import UIKit
import SnapKit
class LabelVC: UIViewController {
    public var lblProductQuantity = UILabel()
    public var circleView = UIView(frame: CGRect(x: 0, y: 0, width: 25 , height: 25))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        view.addSubview(circleView)
        circleView.backgroundColor = UIColor(named:"trendLightOrange")
        circleView.makeCircular()

        circleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        lblProductQuantity.text = "5"
        lblProductQuantity.textAlignment = .center
        lblProductQuantity.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        circleView.addSubview(lblProductQuantity)
        lblProductQuantity.textColor = UIColor(named:"trendOrange")

        lblProductQuantity.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    
}
