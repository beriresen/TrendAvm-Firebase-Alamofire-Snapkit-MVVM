//
//  ProductsCVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//

import UIKit
import SnapKit
import Kingfisher

class ProductsCVC: UICollectionViewCell {
   var viewBackShadow = UIView()
   var viewBack = UIView()
   var image = UIImageView()
   var title = UILabel()
   var price = UILabel()
   var category = UILabel()
   var rate = UILabel()
   var count = UILabel()
   var star1 = UIImageView()
   var star2 = UIImageView()
   var star3 = UIImageView()
   var star4 = UIImageView()
   var star5 = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Setup Components
    private func configure(){
        addSubview(viewBackShadow)
        addSubview(viewBack)
        viewBack.addSubview(image)
        viewBack.addSubview(title)
        viewBack.addSubview(star1)
        viewBack.addSubview(star2)
        viewBack.addSubview(star3)
        viewBack.addSubview(star4)
        viewBack.addSubview(star5)
        viewBack.addSubview(count)
        viewBack.addSubview(price)
        
        viewBackShadow.layer.masksToBounds = false //İçine eklenen viewlar Corner Radiusları etkilemez
        viewBackShadow.backgroundColor = .white
        viewBackShadow.layer.cornerRadius = 16
     
        viewBackShadow.layer.shadowColor = UIColor.lightGray.cgColor
        viewBackShadow.layer.shadowOpacity = 0.4
        viewBackShadow.layer.shadowOffset = .zero
        viewBackShadow.layer.shadowRadius = 10
        viewBackShadow.snp.makeConstraints{ (maker) in
            maker.top.equalTo(8)
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.bottom.equalTo(-8)
        }
        
        viewBack.layer.masksToBounds = true //İçine eklenen viewlar Corner Radiusları etkilemez
        viewBack.backgroundColor = .white
        viewBack.layer.cornerRadius = 16
//        viewBack.layer.borderWidth = 2
//        viewBack.layer.borderColor = UIColor(named: "loginButtonColor")?.cgColor
        viewBack.layer.shadowColor = UIColor.lightGray.cgColor
        viewBack.layer.shadowOpacity = 0.4
        viewBack.layer.shadowOffset = .zero
        viewBack.layer.shadowRadius = 10
        viewBack.snp.makeConstraints{ (maker) in
            maker.top.equalTo(8)
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.bottom.equalTo(-8)
        }
        
        image.layoutIfNeeded()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.snp.makeConstraints{ (maker) in
            maker.top.equalTo(8)
            maker.leading.equalTo(8)
            maker.trailing.equalTo(-8)
            maker.bottom.equalTo(-96)
        }

        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 2
        title.font = UIFont.boldSystemFont(ofSize: 12.0)
        title.snp.makeConstraints{ (maker) in
            maker.top.equalTo(image.snp.bottom).offset(4)
            maker.leading.equalTo(4)
            maker.trailing.equalTo(-4)
        }
        
        
        star1.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(4)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
        }
        
        star2.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(star1.snp.trailing).offset(2)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
        }
        
        star3.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(star2.snp.trailing).offset(2)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
        }
        
        star4.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(star3.snp.trailing).offset(2)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
        }
        
        star5.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(star4.snp.trailing).offset(2)
            maker.width.equalTo(12)
            maker.height.equalTo(12)
        }
        
        count.font = UIFont.boldSystemFont(ofSize: 12.0)
        count.snp.makeConstraints{ (maker) in
            maker.top.equalTo(title.snp.bottom).offset(8)
            maker.leading.equalTo(star5.snp.trailing).offset(4)
            maker.trailing.equalToSuperview().offset(-4)
        }
        
        price.font = UIFont.boldSystemFont(ofSize: 16.0)
        price.textColor = .red
        price.snp.makeConstraints{ (maker) in
            maker.top.equalTo(star1.snp.bottom).offset(4)
            maker.bottom.equalToSuperview().offset(-4)
            maker.leading.equalToSuperview().offset(4)
            maker.trailing.equalToSuperview().offset(-4)
        }
    }
    //MARK: Set Data
    func showData(item:Product){
        title.text = item.title
        count.text = item.rating?.count?.getCountProduct()
        image.kf.setImage(with: URL(string: item.image ?? ""))
        price.text = item.price?.getPriceFormat()
        
        star1.image = UIImage(named: "star_gray")
        star2.image = UIImage(named: "star_gray")
        star3.image = UIImage(named: "star_gray")
        star4.image = UIImage(named: "star_gray")
        star5.image = UIImage(named: "star_gray")
        
        if item.rating?.rate ?? 0 > 0 {
            star1.image = UIImage(named: "star_yellow")
        }
        if item.rating?.rate ?? 0 > 1 {
            star2.image = UIImage(named: "star_yellow")
        }
        if item.rating?.rate ?? 0 > 2 {
            star3.image = UIImage(named: "star_yellow")
        }
        if item.rating?.rate ?? 0 > 3 {
            star4.image = UIImage(named: "star_yellow")
        }
        if item.rating?.rate ?? 0 > 4 {
            star5.image = UIImage(named: "star_yellow")
        }
    }
}
