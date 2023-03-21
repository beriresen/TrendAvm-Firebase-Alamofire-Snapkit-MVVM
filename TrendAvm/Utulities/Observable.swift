//
//  Observable.swift
//  TrendAvm
//
//  Created by Berire Şen Ayvaz on 20.03.2023.
//

import Foundation
class Observable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
