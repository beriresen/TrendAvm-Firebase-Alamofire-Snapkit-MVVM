//
//  SignInVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 2.03.2023.
//

import UIKit

class SignUpVC: UIViewController {
 
    var viewModel = SignUpViewModel()

    private let lblLets = UILabel()
    private let blurViewVStack = UIStackView()
    private let txtEmail = UITextField()
    private let txtUsername = UITextField()
    private let txtPassword = UITextField()
    private let txtFirstName = UITextField()
    private let txtLastName = UITextField()
    private let nameHStack = UIStackView()
    private let txtAddress = UITextField()
    private let adressHStack = UIStackView()
    private let txtCity = UITextField()
    private let txtStreet = UITextField()
    private let txtNumber = UITextField()
    private let signUpBttn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "loginButtonColor")
        configureSignUpVC()
        setupViewModelObserver()

    }
    
    private func configureSignUpVC()  {
        view.addSubview(lblLets)
        view.addSubview(blurViewVStack)
        blurViewVStack.addSubview(txtEmail)
        blurViewVStack.addSubview(txtUsername)
        blurViewVStack.addSubview(txtPassword)
        blurViewVStack.addSubview(nameHStack)
        nameHStack.addArrangedSubview(txtFirstName)
        nameHStack.addArrangedSubview(txtLastName)
        blurViewVStack.addSubview(txtAddress)
        blurViewVStack.addSubview(adressHStack)
        adressHStack.addArrangedSubview(txtCity)
        adressHStack.addArrangedSubview(txtStreet)
        adressHStack.addArrangedSubview(txtNumber)
        view.addSubview(signUpBttn)
        
        adressHStack.axis = .vertical
        adressHStack.alignment = .center
        adressHStack.distribution = .fillEqually
        adressHStack.spacing = 8
        blurViewVStack.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        blurViewVStack.layer.cornerRadius = 8
        blurViewVStack.snp.makeConstraints { make in
            make.top.equalTo(lblLets.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(350)
            
            
            
        }
        lblLets.text = "Let's Sign Up!"
        lblLets.font = UIFont(name: "Helvetica", size: 22)
        lblLets.textColor = .darkGray
        lblLets.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        txtEmail.placeholder = "email"
        txtEmail.textAlignment = .center
        txtEmail.backgroundColor = .white
        txtEmail.layer.cornerRadius = 8
        txtEmail.snp.makeConstraints { make in
            make.top.equalTo(blurViewVStack.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        txtUsername.placeholder = "username"
        txtUsername.textAlignment = .center
        txtUsername.backgroundColor = .white
        txtUsername.layer.cornerRadius = 8
        txtUsername.snp.makeConstraints { make in
            make.top.equalTo(txtEmail.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        txtPassword.placeholder = "password"
        txtPassword.textAlignment = .center
        txtPassword.backgroundColor = .white
        txtPassword.layer.cornerRadius = 8
        txtPassword.snp.makeConstraints { make in
            make.top.equalTo(txtUsername.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        txtFirstName.placeholder = "firstname"
        txtFirstName.textAlignment = .center
        txtFirstName.backgroundColor = .white
        txtFirstName.layer.cornerRadius = 8
        txtFirstName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        txtLastName.placeholder = "lastname"
        txtLastName.textAlignment = .center
        txtLastName.backgroundColor = .white
        txtLastName.layer.cornerRadius = 8
        txtLastName.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        nameHStack.axis = .horizontal
        nameHStack.alignment = .center
        nameHStack.distribution = .fillEqually
        nameHStack.spacing = 8
        nameHStack.snp.makeConstraints { make in
            make.top.equalTo(txtPassword.snp.bottom).offset(15)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
        }
        txtAddress.placeholder = "address"
        txtAddress.textAlignment = .center
        txtAddress.backgroundColor = .white
        txtAddress.layer.cornerRadius = 8
        txtAddress.snp.makeConstraints { make in
            make.top.equalTo(nameHStack.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        adressHStack.axis = .horizontal
        adressHStack.alignment = .center
        adressHStack.distribution = .fillEqually
        adressHStack.spacing = 8
        adressHStack.snp.makeConstraints { make in
            make.top.equalTo(txtAddress.snp.bottom).offset(15)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
        }
        txtCity.placeholder = "City"
        txtCity.textAlignment = .center
        txtCity.backgroundColor = .white
        txtCity.layer.cornerRadius = 8
        txtCity.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        txtStreet.placeholder = "Street"
        txtStreet.textAlignment = .center
        txtStreet.backgroundColor = .white
        txtStreet.layer.cornerRadius = 8
        txtStreet.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        txtNumber.placeholder = "No"
        txtNumber.textAlignment = .center
        txtNumber.backgroundColor = .white
        txtNumber.layer.cornerRadius = 8
        txtNumber.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        signUpBttn.setTitle("Sign Up", for: .normal)
        signUpBttn.layer.borderColor = UIColor.white.cgColor
        signUpBttn.layer.borderWidth = 1
        signUpBttn.setTitleColor(UIColor(named: "greenColor"), for: .normal)
        signUpBttn.layer.cornerRadius = 8
        signUpBttn.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        //  signUpBttn.backgroundColor = .white
        
        
        signUpBttn.addTarget(self, action: #selector(signUpClickked), for: .touchUpInside)
        signUpBttn.snp.makeConstraints { make in
            make.top.equalTo(blurViewVStack.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
    }
    @objc  func signUpClickked(sender:UIButton){
        viewModel.addNewUser(email: "berire@gmail.com", username: "berire19", password: "123Asd654", name: Name(firstname: "berire", lastname: "ayvaz"), address: Adres(city:  "corum", street:  "ulukavaj", number: 2 , zipcode:  "111", geolocation: Geo(lat: "26", long: "45")), phone: "05301108138")
    }
    
    //MARK: - ViewModel ve Data Binding işlemleri
    fileprivate func setupViewModelObserver() {
        
        viewModel.signUpResponse.bind { [weak self] (result) in
            DispatchQueue.main.async { [self] in
     
            }
        }

    }
}
