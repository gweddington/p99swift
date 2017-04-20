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
public func +<T>(left: List<T>, right: List<T>?) -> List<T> {
    if left.nextItem == nil {
        return List(value: left.value, next: right)
    } else {
        return List(left.value) + (left.nextItem! + right)
    }
}
extension List {
    func reverse() -> List<T> {
        return length == 1 ? self : nextItem!.reverse() + List(value)
    }
}


//P06 - Find out whether a linked list is a palindrome.
extension List where T:Equatable {
    func isPalindrome() -> Bool {
        return self == reverse()
    }
}

//P07 - Flatten a nested linked list structure.
extension List {
    func flatten() -> List {
        if let l = value as? List {
            return l.flatten() + nextItem?.flatten()
        }
        return List(value) + nextItem?.flatten()
    }
}

//P08 - Eliminate consecutive duplicates of linked list elements.
extension List where T:Equatable {
    func compress() -> List {
        guard let next = nextItem else { return List(value) }
        if value == next.value {
            return next.compress()
        }
        return List(value) + next.compress()
    }
}

//P09 - Pack consecutive duplicates of linked list elements into sub linked lists.
extension List where T: Equatable {
    func pack() -> List<List<T>> {
        guard nextItem != nil else { return List<List<T>>(List(value))! }
        let pair = span({ $0 == value })
        let head = List<List<T>>(pair.0!)!
        return head + pair.1?.pack()
    }
}
//since span doesn't require equatable, moving it out of the extension with that type condition
extension List {
    func span(_ predicate: (T) -> Bool) -> (List<T>?, List<T>?) {
        if predicate(value) {
            guard let pair = nextItem?.span(predicate) else { return (List(value), nil) }
            var fst = List(value)!
            if let p0 = pair.0 { fst = fst + p0 }
            return (fst, pair.1)
        }
        return (nil, self)
    }
}

//P10 - Run-length encoding of a linked list.
extension List where T: Equatable {
    func encode() -> List<(Int, T)> {
        return pack().map({ ($0.length, $0.value) })
    }
}
extension List {
    func map<R>(_ fn: (T) -> R) -> List<R> {
        let result = List<R>(fn(value))!
        guard let rest = nextItem?.map(fn) else { return result }
        return result + rest
    }
}

//P11 - Modified run-length encoding.
extension List where T: Equatable {
    func encodeModified() -> List<Any> {
        return encode().map({(pair) -> Any in
            pair.0 == 1 ? pair.1 : pair
        })
    }
}

//P12 - Decode a run-length encoded linked list.
typealias EncodedPair = (Int, String)
extension List {
    func decode() -> List<String> {
        let p = value as! EncodedPair   //if you call decode on a List of NOT EncodedPair this will throw at runtime!
        let result = List<String>(Array(repeating: p.1, count: p.0))!
        guard let next = nextItem?.decode() else { return result }
        return result + next
    }
}
//If you want decode to be more strongly typed, i.e. compiler error vs runtime error
func decode(list: List<EncodedPair>) -> List<String> {
    let p = list.value!
    let result = repeatValue(p.1, count: p.0)
    guard let next = list.nextItem else { return result }
    return result + decode(list: next)
}
//Also, it kind of felt like cheating using the built in Array(repeating:count:) initializer, so...
func repeatValue<T>(_ value: T, count: Int) -> List<T> {
    guard count > 1 else { return List<T>(value) }
    return List<T>(value) + repeatValue(value, count: count-1)
}

//P13 - Run-length encoding of a linked list (direct solution).
extension List where T: Equatable {
    func encodeDirect() -> List<(Int, T)> {
        let pair = span({$0 == value})
        let matches = pair.0!
        let rest = pair.1
        return List<(Int, T)>((matches.length, matches.value)) + rest?.encodeDirect()
    }
}

//P14 - Duplicate the elements of a linked list.
extension List {
    func duplicate() -> List {
        return List(value, value) + nextItem?.duplicate()
    }
}

//P15 - Duplicate the elements of a linked list a given number of times.
extension List {
    func duplicate(times: Int) -> List {
        return times <= 1 ? self : List(value) + List(value).duplicate(times: times - 1) + nextItem?.duplicate(times: times)
    }
    //perhaps this is easier to read
    func duplicateAlt(times: Int) -> List {
        if times <= 1 { return self }
        let l = List(value)!
        let headDups = l + l.duplicateAlt(times: times - 1)
        let tailDups = nextItem?.duplicateAlt(times: times)
        return headDups + tailDups
    }
}

//P16 - Drop every Nth element from a linked list.
extension List {
    func drop(every: Int) -> List {
        if every > length || every <= 1 {
            print("Invalid every value: \(every)")
            return self
        }
        return filterAsIndexed(withRoot: 1, {$0.index % every != 0})!
    }
    
    func dropAlt(every: Int) -> List {
        guard every <= length && every > 1 else { return self }
        let len = length
        func dropIfIndexIsFactor(_ item: List, index: Int) -> List {
            guard index < len else { return List(item.value) }
            let next = dropIfIndexIsFactor(item.nextItem!, index: index + 1)
            guard index % every != 0 else { return next }
            return List(item.value) + next
        }
        return dropIfIndexIsFactor(self, index: 1)
    }
    
    func filter(_ predicate: (T) -> Bool) -> List<T>? {
        if predicate(value) {
            return List(value) + nextItem?.filter(predicate)
        }
        return nextItem?.filter(predicate)
    }
    
    func toIndexedList(_ index: Int = 0) -> List<IndexedItem<T>> {
        return List<IndexedItem<T>>(IndexedItem<T>(value: value, index: index)) + nextItem?.toIndexedList(index + 1)
    }
}

extension List {
    func toList<R>() -> List<R> {
        return map({($0 as! IndexedItem<R>).value})
    }
}

//P17 - Split a linked list into two parts.
extension List {
    func split(at index: Int) -> (left: List, right: List) {
        guard index >= 1 && index < length else { return (self, self) }
        if index == 1 {
            return (List(value), nextItem!)
        }
        let (nextLeft, nextRight) = nextItem!.split(at: index - 1)
        return (left: (List(value) + nextLeft), right: nextRight)
    }
}

//P18 - Extract a slice from a linked list.
extension List {
    func slice(_ from: Int, _ to: Int) -> List {
        guard from < to else {
            print("from should be less than to - obviously!")
            return self
        }
        return filterAsIndexed(withRoot: 1, {$0.index > from && $0.index <= to})!
    }
    
    func sliceAlt(_ from: Int, _ to: Int) -> List {
        return split(at: from).right.split(at: (to - from)).left
    }
}

//P19 (**) Rotate a list N places to the left.
extension List {
    func rotate(amount: Int) -> List {
        guard amount != 0 else { return self }
        guard let next = nextItem else { return self }
        let amt = amount < 0 ? length + amount : amount
        return (next + List(value)).rotate(amount: amt - 1)
    }
}

//P20 (*) Remove the Kth element from a linked list.
extension List {
    func remove(at position: Int) -> (rest: List?, removed: T?) {
        guard position >= 0 && position < length else {
            print("Invalid at value: \(position)")
            return (rest: nil, removed: nil)
        }
        guard length > 1 else { return (rest: nil, removed: value) }
        let (left, right) = split(at: position)
        return (rest: left + right.nextItem, removed: right.value)
    }
    
    //alt solution going about it the long way, i.e. not using split or indexedList
    func removeAlt(at position: Int) -> (rest: List?, removed: T?) {
        func r(parents: List, item: List?, index: Int) -> (rest: List?, removed: T?) {
            guard let item = item else { return (rest: parents, removed: nil) }
            if index == 0 {
                return (rest: parents + item.nextItem, removed: item.value)
            }
            return r(parents: parents + List(item.value), item: item.nextItem, index: index - 1)
        }
        if position == 0 {
            return (rest: nextItem, value)
        }
        return r(parents: List(value), item: nextItem, index: position - 1)
    }
    
    //I keep doing this alot so maybe it needs its own func: indexList.filter(predicate).map(backToValueList)
    func filterAsIndexed(withRoot: Int = 0, _ predicate: (IndexedItem<T>) -> Bool) -> List<T>? {
        guard let filtered = toIndexedList(withRoot).filter(predicate) else { return nil }
        return filtered.toList()
    }
}

//P21 - Insert an element at a given position into a linked list.
extension List {
    func insert(at index: Int, value: T) -> List<T> {
        let (left, right) = split(at: index)
        return left + List(value) + right
    }
}

//P22 (*) Create a linked list containing all integers within a given range.
extension List {
    class func range(_ from: Int, _ to: Int) -> List<Int> {
        guard from < to else { return List<Int>(from) }
        return List<Int>(from) + range(from + 1, to)
    }
}
