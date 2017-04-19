//
//  List.swift
//  99Problems
//
//  Created by Greg Weddington on 4/18/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import Foundation

public class List<T> {
    var value: T!
    var nextItem: List<T>?
    
    public convenience init!(_ values: T...) {
        self.init(Array(values))
    }
    
    public convenience init(value: T, next: List<T>?) {
        self.init([value])
        self.nextItem = next
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
    //this kind of sucks, but it will suffice for testing equality for now
    static public func ==(a: List<T>, b: List<T>) -> Bool {
        return a.description == b.description
    }
}

extension List where T: Equatable {
    static public func ==(a: List<T>, b: List<T>) -> Bool {
        return a.value == b.value && a.nextItem == b.nextItem
    }
}

extension List: CustomStringConvertible {
    public var description: String {
        return values().description
    }
}

extension List {
    func clone() -> List<T> {
        return List(values())
    }
    
    func values() -> [T] {
        return [value] + (nextItem?.values() ?? [])
    }
}
