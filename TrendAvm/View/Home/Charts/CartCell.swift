//
//  ChartTVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//
import UIKit
import FirebaseFirestore


class CartCell: UITableViewCell {
    public  var productImage = UIImageView()
    public var lblProductName = UILabel()
    public var lblProductPrice = UILabel()
    public var lblProductQuantity = UILabel()
    public var quantityLabel = UILabel()
    public var plusButton = UIButton(type: .system)
    public var minusButton = UIButton(type: .system)
    let quantityView = UIView()
    
    
    static var customCell = "cell"
    let plusButtonTag = 1
    let minusButtonTag = 2
    var hStack = UIStackView()
    
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        if selected {
        //            // Hücre seçildiğinde
        //            lblProductName.backgroundColor = .systemGreen
        //            lblProductName.textColor = .white
        //        } else {
        //            // Hücre seçimi kaldırıldığında
        //            lblProductName.backgroundColor = .clear
        //            lblProductName.textColor = .black
        //        }
    }
    
    
    private func configure(){
        hStack.addArrangedSubview(quantityLabel)
        hStack.addArrangedSubview(minusButton)
        hStack.addArrangedSubview(lblProductQuantity)
        hStack.addArrangedSubview(plusButton)
        hStack.addSpacer()
        hStack.addSpacer()
        hStack.addSpacer()
        hStack.addArrangedSubview(lblProductPrice)
        
        plusButton.frame = CGRect(x: 50, y: 100, width: 30, height: 30)
        plusButton.tintColor = UIColor(named: "trendOrange")
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.tag = plusButtonTag
        plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        minusButton.frame = CGRect(x: 150, y: 100, width: 30, height: 30)
        minusButton.tintColor = UIColor(named: "trendOrange")
        minusButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        minusButton.tag = minusButtonTag
        minusButton.addTarget(self, action: #selector(minusButtonPressed), for: .touchUpInside)
        
        self.contentView.addSubview(lblProductName)
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(hStack)
        
        
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.snp.makeConstraints{ (make) in
            make.leading.equalTo(lblProductName)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(lblProductName.snp.bottom).offset(8) // lblProductName'in altındaki boşluğu ayarlamak için offset değeri verildi
            make.bottom.equalToSuperview().inset(8)
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
        
        lblProductPrice.font = UIFont(name: "Helvetica-Bold", size: 18)
        lblProductPrice.textColor = UIColor(named:"trendOrange")
        lblProductPrice.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        
        lblProductQuantity.textColor = UIColor(named:"trendOrange")
        lblProductQuantity.font = UIFont(name: "Helvetica", size: 16)
        lblProductQuantity.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        
        quantityLabel.font = UIFont(name: "Helvetica", size: 18)
        quantityLabel.text = "Adet:"
        quantityLabel.textColor = .darkGray
        quantityLabel.font = UIFont(name: "Helvetica", size: 18)
        quantityLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }

    }
    
    @objc func plusButtonPressed(sender: UIButton) {
        if sender.tag == plusButtonTag {
            print("plus button pressed \(sender.tag)")
            NotificationCenter.default.post(name: Notification.Name("PriceIncrease"), object: nil, userInfo: ["value": plusButtonTag])
        }
    }
    
    @objc func minusButtonPressed(sender: UIButton) {
        if sender.tag == minusButtonTag {
            print("minus button pressed \(sender.tag)")
            NotificationCenter.default.post(name: Notification.Name("PriceDecrease"), object: nil, userInfo: ["value": minusButtonTag])
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
