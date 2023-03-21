//
//  Extensions.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 17.03.2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    //MARK: Klavye kapatma
    func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myTapAction))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func myTapAction() {
        view.endEditing(true)
    }
    

    
    //MARK: Alert oluşturm
    func makeAlert(title:String, message:String){
       let alert = UIAlertController(title:  title,
                                     message: message,
                                     preferredStyle: .alert)
       let okButton = UIAlertAction(title:  "Tamam", style: .default)
       alert.addAction(okButton)
       present(alert, animated: true)
   }
}
