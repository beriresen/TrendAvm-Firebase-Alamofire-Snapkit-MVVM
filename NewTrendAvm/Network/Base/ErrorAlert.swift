//
//  ErrorAlert.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 * Burada Apiye yapılan bir istek sonucunda herhangi bir sebepten dolayı hata mesajı göstereceğimiz zaman,
 * sabit olarak tanımladığımız AlertItem nesnelerini çağırabiliyoruz. Herhangi bir ekranda Api kaynaklı bir hata oluştuğunda,
 * tekrar tekrar alert yazmak yerine tek bir yerden çağırabiliyoruz.
 */

import Foundation
import UIKit

struct AlertItem: Identifiable {
    var id = UUID()
    var title:String
    var message:String
    var dismissButton:String
}

enum AlertContext {
    
    //MARK: - Network Errors
    static let invalidURL       = AlertItem(title: "UYARI",
                                            message: "Sunucuya ulaşmaya çalışırken bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.",
                                            dismissButton: "Tamam")
    
    static let unableToComplete = AlertItem(title: "UYARI",
                                            message: "İsteğiniz şu anda tamamlanamıyor. Lütfen internet bağlantınızı kontrol edin.",
                                            dismissButton: "Tamam")
    
    static let invalidResponse  = AlertItem(title: "UYARI",
                                            message: "Sunucudan geçersiz yanıt. Lütfen tekrar deneyin veya desteğe başvurun.",
                                            dismissButton: "Tamam")
    
    static let invalidData      = AlertItem(title: "UYARI",
                                            message: "Sunucudan alınan veriler geçersizdi. Lütfen tekrar deneyin veya desteğe başvurun.",
                                            dismissButton: "Tamam")
    static let cartCreationFailed      = AlertItem(title: "UYARI",
                                            message: "Sepet oluşturma hatası.",
                                            dismissButton: "Tamam")
    
    static let cartUpdateFailed      = AlertItem(title: "UYARI",
                                            message: "Sepet güncelleme hatası.",
                                            dismissButton: "Tamam")
    static let cartAddFailed      = AlertItem(title: "UYARI",
                                            message: "Sepete ekleme hatası.",
                                            dismissButton: "Tamam")
    static let queryFailed      = AlertItem(title: "UYARI",
                                            message: "Sorgu hatası.",
                                            dismissButton: "Tamam")
    
    static let userAuth      = AlertItem(title: "UYARI",
                                            message: "Kullanıcı girişi hatası.",
                                            dismissButton: "Tamam")
}
