//
//  List.swift
//  99Problems
//
//  Created by Greg Weddington on 4/18/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import Foundation

public class List<T> {
    let value: T!
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
    
    func take(_ amount: Int) -> List {
        if amount <= 1 || nextItem == nil {
            return List(value)
        }
        return List(value) + nextItem?.take(amount - 1)
    }

    func foldr<R>(start: R?, reducer: (R?, T) -> R) -> R {
        guard let next = nextItem else { return reducer(start, value) }
        return next.foldr(start: reducer(start, value), reducer: reducer)
    }
    
    func swapValuesAtIndices(_ a: Int, _ b: Int) -> List {
        guard a != b else { return self }
        guard a < b else { return swapValuesAtIndices(b, a) }
        guard a >= 0 && b < length else { return  self }
        let (rest, aVal) = remove(at: a)
        let (rest2, bVal) = rest!.remove(at: b - 1)
        return rest2!.insert(at: a, value: bVal!).insert(at: b, value: aVal!)
    }
    
    func drop(count: Int) -> List? {
        guard count > 0 else { return self.clone() }
        guard let next = nextItem else { return nil }
        return next.drop(count: count - 1)
    }


}

public struct IndexedItem<T> {
    var value: T
    var index: Int
}

