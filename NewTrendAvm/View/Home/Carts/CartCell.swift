//
//  CartCell.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import UIKit
import FirebaseFirestore


class CartCell: UITableViewCell {
   
    var productImage = UIImageView()
    var lblProductName = UILabel()
    var lblKargo = UILabel()
    var lblProductPrice = UILabel()
    var lblProductQuantity = UILabel()
    var lblProductCategory = UILabel()
    var plusButton = UIButton(type: .system)
    var minusButton = UIButton(type: .system)
    var quantityView = UIStackView()
    var hStack = UIStackView()
    var circleView = UIView(frame: CGRect(x: 0, y: 0, width: 25 , height: 25))
    
    static var customCell = "cell"
    let plusButtonTag = 1
    let minusButtonTag = 2
    
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
    
    private func configure(){
        
        hStack.addArrangedSubview(quantityView)
        hStack.addSpacer()
        hStack.addSpacer()
        hStack.addSpacer()
        hStack.addArrangedSubview(lblProductPrice)
        
        self.contentView.addSubview(lblProductName)
        self.contentView.addSubview(lblKargo)
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(hStack)
        
        quantityView.addArrangedSubview(minusButton)
        quantityView.addArrangedSubview(circleView)
        quantityView.addArrangedSubview(plusButton)
        
        circleView.addSubview(lblProductQuantity)

        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.snp.makeConstraints{ (make) in
            make.leading.equalTo(lblProductName)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(lblKargo.snp.bottom).offset(8) // lblProductName'in altındaki boşluğu ayarlamak için offset değeri verildi

        }
        
        productImage.contentMode = .scaleAspectFit
        productImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(60)
            make.height.equalTo(contentView.snp.height).offset(-16)
            make.centerY.equalToSuperview()
            
        }
        
        lblProductName.font = UIFont(name: "Helvetica", size: 16)
        lblProductName.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.trailing.equalTo(-8)
            make.top.equalTo(8)
            make.height.equalTo(18)
        }
        
        lblKargo.textColor = .darkGray
        lblKargo.font = UIFont(name: "Helvetica", size: 12)
        lblKargo.text = "Tahmini Kargoya Teslim: 2 gün içinde"
        lblKargo.snp.makeConstraints { make in
            make.leading.equalTo(productImage.snp.trailing).offset(15)
            make.trailing.equalTo(-8)
            make.top.equalTo(lblProductName.snp.bottom).offset(5)
            make.height.equalTo(18)
        }
        quantityView.axis = .horizontal
        quantityView.layer.borderColor = UIColor(named: "borderGray")?.cgColor
        quantityView.layer.borderWidth = 2
        quantityView.layer.cornerRadius = 17
        quantityView.distribution = .fill
        quantityView.snp.makeConstraints{ (make) in
            make.height.equalTo(34)
            make.width.greaterThanOrEqualTo(95) // quantityView'ı daha geniş yapın
        }
        
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        minusButton.setTitleColor(UIColor(named: "trendOrange"), for: .normal)
        minusButton.tag = minusButtonTag
        minusButton.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.height.equalTo(25)
            make.top.equalTo(quantityView.snp.top).inset(-5)
            make.leading.equalTo(quantityView.snp.leading).inset(8)
        }
        
        lblProductQuantity.text = "5"
        lblProductQuantity.textAlignment = .center
        lblProductQuantity.frame = CGRect(x: 0, y: 0, width: 22, height: 25)
        lblProductQuantity.font = UIFont(name: "Helvetica", size: 14)
        lblProductQuantity.textColor = UIColor(named:"trendOrange")
        lblProductQuantity.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.center.equalToSuperview()
        }
        
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        plusButton.setTitleColor(UIColor(named: "trendOrange"), for: .normal)
        plusButton.tag = plusButtonTag
        plusButton.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.width.equalTo(25)
            make.trailing.equalTo(quantityView.snp.trailing).inset(8).offset(-2) // 2 piksel çerçeve varsayarak.plusButton'un sağ kenarı, çerçevesini de içerecek şekilde ayarlanmalıdır.
        }

        circleView.backgroundColor = UIColor(named:"trendLightOrange")
        circleView.makeCircular()
        circleView.snp.makeConstraints { make in
            make.width.equalTo(25)
            make.top.bottom.equalToSuperview().inset(5) // üst ve alt boşluklar eşit

        }
        
        lblProductPrice.font = UIFont(name: "Helvetica-Semibold", size: 18)
        lblProductPrice.textColor = UIColor(named:"trendOrange")
        lblProductPrice.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
    }
    
}
extension UIStackView {
    func addSpacer() {
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.addArrangedSubview(spacerView)
    }
}

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}
