//
//  main.swift
//  99Problems
//
//  Created by Greg Weddington on 4/18/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import Foundation

//P01 - find the last element of a list
extension List {
    var last: T? {
        return nextItem?.last ?? value
    }
}

//P02 - find the pennultimate element of a list
extension List {
    var pennultimate: T? {
        return nextItem?.nextItem == nil ? value : nextItem?.pennultimate
    }
}

//P03 - find the kth element of a list
extension List {
    subscript(index: Int) -> T? {
        guard index >= 0 else {
            print("index should be >= 0")
            return nil
        }
        return index == 0 ? value : nextItem?[index-1]
    }
}

//P04 - Find the number of elements of a linked list.
extension List {
    var length: Int {
        return (nextItem?.length ?? 0) + 1
    }
}

//P05 - Reverse a linked list.
public func +<T>(left: List<T>, right: List<T>) -> List<T> {
    if left.nextItem == nil {
        let result = left.clone()
        result.nextItem = right
        return result
    } else {
        return List([left.value]) + (left.nextItem! + right)
    }
}
extension List {
    func reverse() -> List<T> {
        return length == 1 ? self : nextItem!.reverse() + List([value])
    }
    
    //I used these 2 for the operator (+) implementation
    //I also used values for CustomStringConvertible
    func clone() -> List<T> {
        return List(values())
    }
    
    func values() -> [T] {
        return [value] + (nextItem?.values() ?? [])
    }
}

