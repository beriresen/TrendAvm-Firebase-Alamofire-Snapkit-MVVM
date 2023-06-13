//
//  Observable.swift
//  NewTrendAvm
//
//  Created by Berire Şen Ayvaz on 11.06.2023.
//
/**
 *Burada Generic Observable oluşturuluyor.
 *içerisinde 'Value' adında optional bir özellik oluşturuluyor. Value  değiştiğinde didSet özelliği tetikleniyor.
 *didSet  tetiklendiğinde ise, observer adında tanımladığımız Closure çağırılıyor ve değer gönderiliyor.
 *Bu sayede değer değiştiğinde dinleyiciler otomatik olarak çalışıyor.
 *
 *Bu sınıf base bir yapı olmakla birlikte, tüm view controller ve tüm view modellerde çalışması için tasarlandı.
 *Viewmodel içerisinde tanımlanan Observable nesnesinde veri değiştiğinde, ViewController içerisinde tanımlanan dinleyici bind otomatik olarak çalıştırılır.
 *Bu sınıf ile ViewController ve ViewModel arasındaki veri iletişimi gerçekleştirilmektedir.
 */
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
