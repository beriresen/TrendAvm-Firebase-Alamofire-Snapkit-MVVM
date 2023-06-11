//
//  LogOutVC.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
import UIKit
import FirebaseAuth

class LogOutVC: UIViewController {
    
    var logOutBttn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = . white
        configureSignOutVC()
    }
    
    private func configureSignOutVC()  {
        view.addSubview(logOutBttn)
        logOutBttn.setTitle("Çıkış", for: .normal)
        logOutBttn.setTitleColor(.white, for: .normal)
        logOutBttn.backgroundColor = UIColor(named: "loginButtonColor")
        logOutBttn.layer.cornerRadius = 8
        
        logOutBttn.addTarget(self, action: #selector(signOutClickked), for: .touchUpInside)
        logOutBttn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
    
    @objc  func signOutClickked(sender:UIButton){
        do {
            try Auth.auth().signOut()
            let loginVC = LoginVC()
               loginVC.logout()

        }catch{
            print("error")
        }
  
    }
    
}
