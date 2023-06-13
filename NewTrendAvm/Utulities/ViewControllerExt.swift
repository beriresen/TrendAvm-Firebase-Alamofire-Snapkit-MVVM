//
//  ViewControllerExt.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Foundation
import UIKit
import FirebaseAuth
import MBProgressHUD

extension UIViewController{
    
    func pushCartVC() {
        let cartVC = CartVC()
        navigationController?.pushViewController(cartVC, animated: true)
    }
    func authenticateUser() -> String? {
        guard let userId = Auth.auth().currentUser?.email else {
            makeAlert(title: "Hata", message: "Kullanıcının kimliği doğrulanmadı.")
            return nil
        }
        return userId
    }
    func showProgressHUD() {
           let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
           progressHUD.label.text = "Loading"
       }

       func hideProgressHUD() {
           MBProgressHUD.hide(for: self.view, animated: true)
       }
}
