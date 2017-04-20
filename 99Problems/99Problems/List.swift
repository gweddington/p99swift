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
    
    //I started P20 with take but then realized I didn't need it, but its probably a good tool to have
    func take(_ index: Int) -> List {
        if index <= 1 || nextItem == nil {
            return List(value)
        }
        return List(value) + nextItem?.take(index - 1)
    }
    

}

public struct IndexedItem<T> {
    var value: T
    var index: Int
}

