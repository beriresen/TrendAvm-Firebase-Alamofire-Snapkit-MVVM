//
//  LognViewController.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 1.03.2023.
//

import UIKit
import SnapKit

class LoginVC: UIViewController {
    
    var viewModel = LoginViewModel()
    
    private let backgroundImg = UIImageView()
    private let lblTitle = UILabel()
    private let blurView = UIView()
    private let txtUsername = UITextField()
    private let txtPassword = UITextField()
    private let indicatorView = UIActivityIndicatorView()
    private let loginBttn = UIButton()
    private let signInBttn = UIButton()
    private let forgetBttn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = . white
        configureLoginVC()
        setupViewModelObserver()
        
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
        txtUsername.text = "mor_2314"
        txtUsername.textAlignment = .center
        txtUsername.backgroundColor = .white
        txtUsername.layer.cornerRadius = 8
        txtUsername.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
        
        txtPassword.placeholder = "password"
        txtPassword.text = "83r5^_"
        txtPassword.textAlignment = .center
        txtPassword.backgroundColor = .white
        txtPassword.layer.cornerRadius = 8
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
        signInBttn.addTarget(self, action: #selector(SignInClickked), for: .touchUpInside)
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
        viewModel.login(username: txtUsername.text ?? "", password: txtPassword.text ?? "")
        //         indicatorView.startAnimating()
        
    }
    
    @objc  func SignInClickked(sender:UIButton){
        let signInVC = SignUpVC()
        navigationController?.pushViewController(signInVC, animated: true)
    }
    @objc  func forgetnClickked(sender:UIButton){
//        let signInVC = PasswordUpdateVC()
//        navigationController?.pushViewController(signInVC, animated: true)
    }
    //MARK: - ViewModel ve Data Binding işlemleri
    fileprivate func setupViewModelObserver() {
        
        viewModel.loginResponse.bind { [weak self] (result) in
            DispatchQueue.main.async { [self] in
                let homeVC = ProductsVC ()
                self?.navigationController?.pushViewController(homeVC, animated: true)
            }
        }
        viewModel.isLoading.bind { [weak self] (isLoading) in
            guard let isLoading = isLoading else { return }
            DispatchQueue.main.async { [self] in
                isLoading ? self?.indicatorView.startAnimating() : self?.indicatorView.stopAnimating()
                self?.indicatorView.isHidden = !isLoading
            }
        }
        viewModel.alertItem.bind{ [weak self] (alert) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: self?.viewModel.alertItem.value?.title ?? "Uyarı",
                                              message: "Kullanıcı Adı ve Şifrenizi Kontrol Ediniz",
                                              preferredStyle: .alert)
                let okButton = UIAlertAction(title: self?.viewModel.alertItem.value?.dismissButton ?? "Tamam", style: .default)
                alert.addAction(okButton)
                self?.present(alert, animated: true)
            }
        }
    }
    
}

