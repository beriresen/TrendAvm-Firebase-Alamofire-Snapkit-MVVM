//
//  FavoritesCell.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 9.05.2023.
//

import UIKit

class FavoritesCell: UITableViewCell {
    var hStack = UIStackView()

    var productImage = UIImageView()
    var lblProductName = UILabel()
    var lblProductPrice = UILabel()
    var lblProductCategory = UILabel()
    var lblDescription = UILabel()
    var viewPoint = UIView()
    var lblRate = UILabel()
    var lblCount = UILabel()
    var star1 = UIImageView()
    var star2 = UIImageView()
    var star3 = UIImageView()
    var star4 = UIImageView()
    var star5 = UIImageView()
    var btnSepeteEkle = UIButton()

    static var favCustomCell = "favCustomCell"

    //Objects
    private var product = Product()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    //MARK: Setup Components
    private func configure(){
        self.contentView.addSubview(productImage)

        self.contentView.addSubview(lblProductCategory)
        self.contentView.addSubview(lblProductName)
        self.contentView.addSubview(viewPoint)
        self.contentView.addSubview(lblProductPrice)
        self.contentView.addSubview(btnSepeteEkle)


        viewPoint.addSubview(lblRate)
        viewPoint.addSubview(star1)
        viewPoint.addSubview(star2)
        viewPoint.addSubview(star3)
        viewPoint.addSubview(star4)
        viewPoint.addSubview(star5)
        viewPoint.addSubview(lblCount)
        
        productImage.contentMode = .scaleAspectFit
        productImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(60)
            make.height.equalTo(contentView.snp.height).offset(-16)
            make.centerY.equalToSuperview()
            
        }
        lblProductCategory.font = UIFont.boldSystemFont(ofSize: 16)
        lblProductCategory.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
            make.height.equalTo(18)
        }
        
        lblProductName.textColor = .darkGray
        lblProductName.numberOfLines = 0
        lblProductName.font = UIFont(name: "Helvetica", size: 13)
        lblProductName.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.top.equalTo(lblProductCategory.snp.bottom).offset(5)
            make.trailing.equalTo(-8)
            make.height.equalTo(18)
        }
        

        viewPoint.snp.makeConstraints { (make) in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.top.equalTo(lblProductName.snp.bottom).offset(5)
            make.trailing.equalTo(-8)
        }
        
        lblRate.font = UIFont(name: "Helvetica", size: 13)
        lblRate.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.centerY.equalToSuperview()
        }
        
        star1.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(lblRate.snp.trailing).offset(8)
            maker.width.equalTo(8)
            maker.height.equalTo(8)
            maker.centerY.equalToSuperview()
        }
        
        star2.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star1.snp.trailing).offset(4)
            maker.width.equalTo(8)
            maker.height.equalTo(8)
            maker.centerY.equalToSuperview()
        }
        
        star3.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star2.snp.trailing).offset(4)
            maker.width.equalTo(8)
            maker.height.equalTo(8)
            maker.centerY.equalToSuperview()
        }
        
        star4.snp.makeConstraints{ (make) in
            make.leading.equalTo(star3.snp.trailing).offset(4)
            make.width.equalTo(8)
            make.height.equalTo(8)
            make.centerY.equalToSuperview()
        }
        
        star5.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star4.snp.trailing).offset(4)
            maker.width.equalTo(8)
            maker.height.equalTo(8)
            maker.centerY.equalToSuperview()
            
        }
        lblCount.font = UIFont(name: "Helvetica", size: 13)
        lblCount.snp.makeConstraints{ (maker) in
            maker.leading.equalTo(star5.snp.trailing).offset(8)
            maker.top.equalTo(0)
            maker.bottom.equalTo(0)
            maker.centerY.equalToSuperview()
        }
        lblProductPrice.textColor = UIColor(named:"trendOrange")
        lblProductPrice.numberOfLines = 0
        lblProductPrice.font = UIFont(name: "Helvetica", size: 13)
        lblProductPrice.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.top.equalTo(viewPoint.snp.bottom).offset(15)
            make.trailing.equalTo(btnSepeteEkle.snp.leading).offset(-8) // btnSepeteEkle butonuna göre sağa hizala
            make.height.equalTo(18)
        }
        
        btnSepeteEkle.setTitleColor(UIColor(named:"trendDarkOrange"), for: .normal)
        btnSepeteEkle.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        btnSepeteEkle.layer.cornerRadius = 4
        btnSepeteEkle.layer.borderColor = UIColor(named:"trendDarkOrange")?.cgColor
        btnSepeteEkle.layer.borderWidth =  1
        btnSepeteEkle.backgroundColor = .white
        btnSepeteEkle.setTitle("Sepete Ekle", for: .normal)
        btnSepeteEkle.snp.makeConstraints { make in
            make.top.equalTo(viewPoint.snp.bottom).offset(10)
            make.trailing.equalToSuperview().offset(-10)
//            make.leading.equalTo(lblProductPrice.snp.trailing).offset(15)
            make.width.equalTo(80) // Örnek bir genişlik değeri
            make.height.equalTo(30) // Örnek bir yükseklik değeri
        }
        
    }
    
    @objc  func sepeteEkle(sender:UIButton){
        
    }
}
