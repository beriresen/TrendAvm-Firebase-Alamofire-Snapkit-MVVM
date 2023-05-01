//
//  LogOutVC.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 19.04.2023.
//

import UIKit
import FirebaseAuth

class LogOutVC: UIViewController {
    var signOutBttn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = . white
        configureSignOutVC()
    }
    
    private func configureSignOutVC()  {
        view.addSubview(signOutBttn)
        signOutBttn.setTitle("Sign Up", for: .normal)
        signOutBttn.layer.borderColor = UIColor.white.cgColor
        signOutBttn.layer.borderWidth = 1
        signOutBttn.setTitleColor(UIColor(named: "greenColor"), for: .normal)
        signOutBttn.layer.cornerRadius = 8
        signOutBttn.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        signOutBttn.addTarget(self, action: #selector(signOutClickked), for: .touchUpInside)
        signOutBttn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()

        }
    }
    @objc  func signOutClickked(sender:UIButton){
        do {
            try Auth.auth().signOut()
//            let loginVC = LoginVC()
//            navigationController?.pushViewController(loginVC, animated: true)
            
        }catch{
            print("error")
        }
    }
    
}
