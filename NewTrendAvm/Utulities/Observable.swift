//
//  Observable.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
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
