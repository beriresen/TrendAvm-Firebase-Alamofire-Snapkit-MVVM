//
//  ViewControllerExt.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//

import Foundation
import UIKit
import FirebaseAuth

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
}
