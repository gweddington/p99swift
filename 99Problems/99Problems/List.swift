//
//  List.swift
//  99Problems
//
//  Created by Greg Weddington on 4/18/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import Foundation

public class List<T: Equatable> {
    var value: T!
    var nextItem: List<T>?
    
    public convenience init!(_ values: T...) {
        self.init(Array(values))
    }
    
    init!( _ values: Array<T>) {
        var values = values
        if values.count == 0 {
            return nil
        }
        value = values.removeFirst()
        nextItem = List(values)
    }
}


extension List: Equatable {
    static public func ==(a: List<T>, b: List<T>) -> Bool {
        return a.value == b.value && a.nextItem == b.nextItem
    }
}

extension List: CustomStringConvertible {
    public var description: String {
        return values().description
    }
}

