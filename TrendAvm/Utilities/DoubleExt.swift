//
//  DoubleExt.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 6.03.2023.
//

import Foundation
extension Double {
    
    //Ürünlerin değerini gösterebilmek için basamaklama ve ₺ değerinin eklendiği özellik
    func getPriceFormat() -> String {
        let ff = NumberFormatter()
        ff.numberStyle = .decimal
        ff.currencyGroupingSeparator = "."
        ff.currencyDecimalSeparator = ","
        ff.usesGroupingSeparator = true
        ff.minimumFractionDigits = 2
        ff.maximumFractionDigits = 2
        ff.generatesDecimalNumbers = true
        
        if let item = ff.string(from:NSNumber(value: self)) {
            return "₺ " + item
        }else{
            return "Exception!"
        }
    }
}
