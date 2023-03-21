//
//  LoginVC.swift
//  TrendyAvm
//
//  Created by Berire Şen Ayvaz on 17.03.2023.
//

import UIKit
import SnapKit
import FirebaseAuth


class LoginVC: UIViewController {
    
    
    var backgroundImg = UIImageView()
    var lblTitle = UILabel()
    var blurView = UIView()
    var txtUsername = UITextField()
    var txtPassword = UITextField()
    var indicatorView = UIActivityIndicatorView()
    var loginBttn = UIButton()
    var signInBttn = UIButton()
    var forgetBttn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = . white
        configureLoginVC()
        
        addTapGestureRecognizer()
        
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
            let homeVC = ProductsVC()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    
    
    private func configureLoginVC()  {
        view.addSubview(backgroundImg)
        view.addSubview(lblTitle)
        view.addSubview(blurView)
        blurView.addSubview(txtUsername)
        blurView.addSubview(txtPassword)
        blurView.addSubview(loginBttn)
        view.addSubview(indicatorView)
        view.addSubview(signInBttn)
        view.addSubview(forgetBttn)
        
        
        backgroundImg.image = UIImage(named: "loginbackground", variableValue: 0)
        backgroundImg.contentMode = .scaleAspectFill
        
        backgroundImg.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        lblTitle.text = "Hello!"
        lblTitle.font = UIFont(name: "Helvetica", size: 22)
        lblTitle.textColor = .darkGray
        lblTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(260)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        blurView.layer.cornerRadius = 8
        blurView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(180)
        }
        
        txtUsername.placeholder = "username"
        txtUsername.textAlignment = .center
        txtUsername.backgroundColor = .white
        txtUsername.layer.cornerRadius = 8
        txtUsername.text = "beriresen@gmail.com"
        txtUsername.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        txtPassword.placeholder = "password"
        txtPassword.text = "123456"
        txtPassword.textAlignment = .center
        txtPassword.backgroundColor = .white
        txtPassword.layer.cornerRadius = 8
        txtPassword.keyboardType = .numberPad
        txtPassword.isSecureTextEntry = true
        txtPassword.snp.makeConstraints { make in
            make.top.equalTo(txtUsername.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        loginBttn.setTitle("Login", for: .normal)
        loginBttn.setTitleColor(.white, for: .normal)
        loginBttn.backgroundColor = UIColor(named: "loginButtonColor")
        loginBttn.layer.cornerRadius = 8
        loginBttn.addTarget(self, action: #selector(loginClickked), for: .touchUpInside)
        loginBttn.snp.makeConstraints { make in
            make.top.equalTo(txtPassword.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        indicatorView.color = .white
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        signInBttn.setTitle("Sign Up.", for: .normal)
        signInBttn.setTitleColor(.white, for: .normal)
        signInBttn.addTarget(self, action: #selector(SignUpClickked), for: .touchUpInside)
        signInBttn.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-45)
        }
        
        forgetBttn.setTitle("Forget Password.", for: .normal)
        forgetBttn.setTitleColor(.systemBlue, for: .normal)
        forgetBttn.titleLabel?.font =  UIFont(name: "Halvetica", size: 8)
        forgetBttn.addTarget(self, action: #selector(forgetnClickked), for: .touchUpInside)
        forgetBttn.snp.makeConstraints { make in
            make.top.equalTo(signInBttn.snp.bottom).offset(0)
            make.trailing.equalToSuperview().offset(-45)
        }
        
        
    }
    @objc  func loginClickked(sender:UIButton){
        //         indicatorView.startAnimating()
        
        if  txtUsername.text != "" && txtPassword.text != ""  {
            
            Auth.auth().signIn(withEmail: txtUsername.text!, password: txtPassword.text!) { (authdata,error) in
                
                if error != nil {
                    self.makeAlert(title: "Uyarı", message: error?.localizedDescription ?? "Error" )
                }else {
                    let homeVC = ProductsVC()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }else {
            makeAlert(title:  "Uyarı", message: "Kullanıcı Adı ve Şifrenizi Kontrol Ediniz")
            
        }
    }
    
    @objc  func SignUpClickked(sender:UIButton){
        let signInVC = SignUpVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    
    @objc  func forgetnClickked(sender:UIButton){
        //        let signInVC = PasswordUpdateVC()
        //        navigationController?.pushViewController(signInVC, animated: true)
    }
    
}
