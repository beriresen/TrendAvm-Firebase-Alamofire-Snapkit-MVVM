//
//  ErrorAlert.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 1.03.2023.
//

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
}
