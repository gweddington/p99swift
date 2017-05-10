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
//Appendix 1A
/// Conforming to the Sequence Protocol
/// ===================================
///
/// Making your own custom types conform to `Sequence` enables many useful
/// operations, like `for`-`in` looping and the `contains` method, without
/// much effort. To add `Sequence` conformance to your own custom type, add a
/// `makeIterator()` method that returns an iterator.
///
/// Alternatively, if your type can act as its own iterator, implementing the
/// requirements of the `IteratorProtocol` protocol and declaring conformance
/// to both `Sequence` and `IteratorProtocol` are sufficient.
///
/// Here's a definition of a `Countdown` sequence that serves as its own
/// iterator. The `makeIterator()` method is provided as a default
/// implementation.
///
///     struct Countdown: Sequence, IteratorProtocol {
///         var count: Int
///
///         mutating func next() -> Int? {
///             if count == 0 {
///                 return nil
///             } else {
///                 defer { count -= 1 }
///                 return count
///             }
///         }
///     }
extension List: Sequence, IteratorProtocol {
    public func next() -> T? {
        return nextItem?.value
    }
}

public struct IndexedItem<T> {
    var value: T
    var index: Int
}


public class BinaryTree<T> {
    var node: T
    var left: BinaryTree<T>?
    var right: BinaryTree<T>?
    
    init(node: T, left: BinaryTree<T>? = nil, right: BinaryTree<T>? = nil) {
        self.node = node
        self.left = left
        self.right = right
    }
}

extension BinaryTree: CustomStringConvertible {
    public var description: String {
        return displayWithLevel()
//        let len = length
//        let spacer = repeatElement("  ", count: len - 1).joined()
//        var s = "\(spacer)Node \(node)"
//        if let l = left?.description { s += "\n\(spacer)L \(l)" } else { s += " nil" }
//        if let r = right?.description { s += "\n\(spacer)R \(r)" } else { s += " nil" }
//        if len > 1 { s = "\n\(s)" }
//        return s
    }
    public func displayWithLevel(level: Int = 0) -> String {
        let spacer = repeatElement("  ", count: level).joined()
        var ls = "L\(left?.displayWithLevel(level: level+1) ?? "")"
        var rs = "R\(right?.displayWithLevel(level: level+1) ?? "")"
        if left != nil { ls = "\n\(ls)" }
        if right != nil { rs = "\n\(rs)" }
        let brk = level == 0 ? "\n" : ""
        return "\(brk)\(spacer)\(level)-Node \(node)\(ls)\(rs)"
    }
}

extension BinaryTree {
    public var length: Int {
        return 1 + (left?.length ?? 0) + (right?.length ?? 0)
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
}
