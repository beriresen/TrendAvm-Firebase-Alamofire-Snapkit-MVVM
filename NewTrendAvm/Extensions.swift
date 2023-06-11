//
//  Extensions.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
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
    
    
    func makeActionSheet(title: String, message:String){
        let actionSheet = UIAlertController(title: nil,
                                            message: message,
                                            preferredStyle: .actionSheet)
         let blockAction = UIAlertAction(title: "Sil", style: .destructive)

         let cancelAction = UIAlertAction(title: "Vazgeç", style: .cancel)

        actionSheet.addAction(blockAction)
         actionSheet.addAction(cancelAction)
         self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func makeAlertWithTwoButtons(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: .default) { (_) in
            print("Tamam")
        }
        
        let cancelButton = UIAlertAction(title: "İptal", style: .cancel)
        
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true)
    }
}
