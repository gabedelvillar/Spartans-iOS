//
//  Bindable.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/6/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
