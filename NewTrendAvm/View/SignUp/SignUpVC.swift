//
//  SignUpVC.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    var lblLets = UILabel()
    var blurViewVStack = UIStackView()
    var txtEmail = UITextField()
    var txtPassword = UITextField()
    var signUpBttn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "loginButtonColor")
        configureSignUpVC()
        addTapGestureRecognizer()
    }
    
    private func configureSignUpVC()  {
        view.addSubview(lblLets)
        view.addSubview(blurViewVStack)
        blurViewVStack.addSubview(txtEmail)
        blurViewVStack.addSubview(txtPassword)
        view.addSubview(signUpBttn)
    
        blurViewVStack.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        blurViewVStack.layer.cornerRadius = 8
        blurViewVStack.snp.makeConstraints { make in
            make.top.equalTo(lblLets.snp.bottom).offset(15)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(130)
        }
        
        lblLets.text = "Let's Sign Up!"
        lblLets.font = UIFont(name: "Helvetica", size: 22)
        lblLets.textColor = .darkGray
        lblLets.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        txtEmail.autocorrectionType = .no //textview deki oto düzeltmeyi kapatır
        txtEmail.autocapitalizationType = .none //textview büyük harfle başlamasını engeller
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
        
        txtPassword.placeholder = "password"
        txtPassword.textAlignment = .center
        txtPassword.backgroundColor = .white
        txtPassword.layer.cornerRadius = 8
        txtPassword.keyboardType = .numberPad
         txtPassword.snp.makeConstraints { make in
            make.top.equalTo(txtEmail.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
               
        signUpBttn.setTitle("Sign Up", for: .normal)
        signUpBttn.layer.borderColor = UIColor.white.cgColor
        signUpBttn.layer.borderWidth = 1
        signUpBttn.setTitleColor(UIColor(named: "greenColor"), for: .normal)
        signUpBttn.layer.cornerRadius = 8
        signUpBttn.backgroundColor = UIColor.black.withAlphaComponent(0.25)        
        signUpBttn.addTarget(self, action: #selector(signUpClickked), for: .touchUpInside)
        signUpBttn.snp.makeConstraints { make in
            make.top.equalTo(blurViewVStack.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.width.equalTo(150)
        }
    }

    @objc  func signUpClickked(sender:UIButton){
        showProgressHUD()
        if  txtEmail.text != "" && txtPassword.text != ""  {
            
            Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!) { (authdata,error) in
                self.hideProgressHUD()

                if error != nil {
                    self.makeAlert(title:  "Uyarı", message: "Kullanıcı Adı ve Şifrenizi Kontrol Ediniz")

                }else {
                    let loginVC = LoginVC()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            }
        }
        
    }

}

