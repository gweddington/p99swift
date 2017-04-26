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
        return pack().mapList({ ($0.length, $0.value) })
    }
}
extension List {
    func mapList<R>(_ fn: (T) -> R) -> List<R> {
        let result = List<R>(fn(value))!
        guard let rest = nextItem?.mapList(fn) else { return result }
        return result + rest
    }
}

//P11 - Modified run-length encoding.
extension List where T: Equatable {
    func encodeModified() -> List<Any> {
        return encode().mapList({(pair) -> Any in
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
        return filterListAsIndexed(withRoot: 1, {$0.index % every != 0})!
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
    
    func filterList(_ predicate: (T) -> Bool) -> List<T>? {
        if predicate(value) {
            return List(value) + nextItem?.filterList(predicate)
        }
        return nextItem?.filterList(predicate)
    }
    
    func toIndexedList(_ index: Int = 0) -> List<IndexedItem<T>> {
        return List<IndexedItem<T>>(IndexedItem<T>(value: value, index: index)) + nextItem?.toIndexedList(index + 1)
    }
}

extension List {
    func toList<R>() -> List<R> {
        return mapList({($0 as! IndexedItem<R>).value})
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
        return filterListAsIndexed(withRoot: 1, {$0.index > from && $0.index <= to})!
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
        if position == 0 {
            return (rest: nextItem, removed: value)
        }
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
    
    //I keep doing this alot so maybe it needs its own func: indexList.filterList(predicate).mapList(backToValueList)
    func filterListAsIndexed(withRoot: Int = 0, _ predicate: (IndexedItem<T>) -> Bool) -> List<T>? {
        guard let filterListed = toIndexedList(withRoot).filterList(predicate) else { return nil }
        return filterListed.toList()
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

//P23 (**) Extract a given number of randomly selected elements from a linked list.
extension List {
    //note: I diverged from the recommended signature to one that accepts a closure
    //to acquire the next random index. This way the function has a predictable 
    //output, so long as the generator closure is predictable
    func randomSelect(amount: Int, generator: @escaping () -> Int) -> List? {
        guard amount > 0 else { return nil }
        let index = generator()
        guard index >= 0 && index < length else {
            //invalid random index - I could correct it but I chose to just retry
            return randomSelect(amount: amount, generator: generator)
        }
        let item = List(self[index]!)!
        return item + randomSelect(amount: amount - 1, generator: generator)
    }
}

//P24 (*) Lotto: Draw N different random numbers from the set 1..M.
extension List {
    //note: just like P23, I defined it to take in a generator fn instead of choosing a random number
    //I suspose one could easily write an overload that just takes the 2 numbers and calls
    //this method by providing it a random generator
    class func lotto(_ numbers: Int, _ maximum: Int, generator: @escaping () -> Int) -> List<Int> {
        //for the sake of simplicity, if the generated number exceeds maximum, just use maximum
        //we could, instead, retry or something but...
        let num = Swift.min(generator(), maximum)
        guard numbers > 1 else { return List<Int>(num) }
        return List<Int>(num) + lotto(numbers - 1, maximum, generator: generator)
    }
    //so the random version w/o supplying a random number generator, i.e. impure
    class func lotto(_ numbers: Int, _ maximum: Int) -> List<Int> {
        return lotto(numbers, maximum) { () in
            return Int(arc4random_uniform(UInt32(maximum)) + 1)
        }
    }
}

//P25 (*) Generate a random permutation of the elements of a linked list.
extension List {
    func randomPermute(generator: @escaping (Int) -> Int) -> List {
        let index = generator(length - 1)
        let (rest, removed) = remove(at: index)
        guard let item = removed else {
            return randomPermute(generator: generator)  //try again
        }
        return List(item) + rest?.randomPermute(generator: generator)
    }
}

//P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a linked list.
extension List {
    func combinations(group: Int) -> List<List<T>> {
        guard nextItem != nil else { return List<List<T>>(List<T>(value)) }
        guard group > 1 else {
            return List<List<T>>(List<T>(value)) + nextItem!.combinations(group: group)
        }
        let combos = nextItem!.combinations(group: group - 1).mapList({ List<T>(value) + $0 })
            + nextItem!.combinations(group: group)
        return combos.filterList({$0.length == group}) ?? combos
    }
}

//P26B (**) Generate the permutations of K distinct objects chosen from the N elements of a linked list.
extension List where T:Equatable {
    func permutations(group: Int) -> List<List<T>> {
        func ps(rotation: Int) -> List<List<T>> {
            guard rotation > 0 else { return combinations(group: group) }
            return rotate(amount: rotation).combinations(group: group) + ps(rotation: rotation - 1)
        }
        return ps(rotation: length - 1)
            .removeDups()
    }

    func removeDups() -> List {
        guard let next = nextItem else { return List(value) }
        if next.listContains(value) {
            return next.removeDups()
        }
        return List(value) + next.removeDups()
    }
}

//P27 (**) Group the elements of a set into disjoint subsets.
//I can't do this one :(
extension List where T: Equatable {
    func group3() -> List<List<List<T>>>? {
        //groups of 2, 3, 4
//        let twos = combinations(group: 2)
//        let threes = combinations(group: 3)
//        let fours = combinations(group: 4)
        return nil
//        func combination(n: Int, list: List<T>) -> List<(List<T>, List<T>?)> {
//            let x = list.value!, xs = list.nextItem
//            guard n > 0 && list.nextItem != nil else {
//                return List<(List<T>, List<T>?)>((List<T>(x), xs))
//            }
//            func addToLeft(_ p: (List<T>,List<T>?)) -> (List<T>,List<T>?) {
//                return (List<T>(x) + p.0, p.1)
//            }
//            func addToRight(_ p: (List<T>,List<T>?)) -> (List<T>,List<T>?) {
//                return (p.0, List<T>(x) + p.1)
//            }
//            return combination(n: n - 1, list: xs!).mapList(addToLeft)
//                 + combination(n: n, list: xs!).mapList(addToRight)
//        }
//        
//        let twos = combination(n: 2, list: self).foldr(start: nil, reducer: {(b,p) -> List<List<List<T>>> in
//            if p.1 == nil && b == nil { return List<List<List<T>>>(List<List<T>>(p.0)) }
//            return p.1!.group3().mapList({List<List<T>>(p.0) + $0}) + b
//        })
//        let threes = combination(n: 3, list: self).foldr(start: nil, reducer: {(b,p) -> List<List<List<T>>> in
//            if p.1 == nil && b == nil { return List<List<List<T>>>(List<List<T>>(p.0)) }
//            return p.1!.group3().mapList({List<List<T>>(p.0) + $0}) + b
//        })
//        let fours = combination(n: 4, list: self).foldr(start: nil, reducer: {(b,p) -> List<List<List<T>>> in
//            if p.1 == nil && b == nil { return List<List<List<T>>>(List<List<T>>(p.0)) }
//            return p.1!.group3().mapList({List<List<T>>(p.0) + $0}) + b
//        })
//
//        print(twos)
//        return twos + threes + fours
    }
    
    //combine each elem of the list with every element of the other list
    // [1,2] combine [3,4,5] = [[1,3],[1,4],[1,5],[2,3],[2,4],[2,5]]
    func combine(with other: List<T>) -> List<List<List<T>>> {
        return mapList({a in
            other.mapList({b in
                List<T>(a) + List<T>(b)
            })
        });
    }
}

//P28 (**) Sorting a linked list of linked lists according to length of sublists.
//Note: I had an issue with using as? and/or is List/List<T> with lsort as an extension method
//so I am implementing it as an external function instead
func lsort<T>(list: List<List<T>>) -> List<List<T>> {
    return listSort(list: list, by: {$0.length})
}

//P28B (**) Sorting a linked list of linked lists according to their length frequency.
func lsortFreq<T>(list: List<List<T>>) -> List<List<T>> {
    func sortByFreq(_ unsorted: List<(Int, List<T>)>) -> List<(Int, List<T>)> {
        return listSort(list: unsorted, by: {$0.0})
    }
    func freqOfLength(_ list: List<(Int, List<T>)>, rotation: Int = 0) -> List<(Int, List<T>)> {
        let (len, ls) = list.value
        guard let next = list.nextItem else { return List<(Int, List<T>)>((1, ls)) }
        let freq = (next.filterList({$0.0 == len})?.length ?? 0) + 1
        guard rotation < list.length - 1 else { return List<(Int, List<T>)>((freq, ls)) }
        return List<(Int, List<T>)>((freq, ls)) +
            freqOfLength(next + List<(Int, List<T>)>((len, ls)),
                         rotation: rotation + 1)
    }
    func fromPairToItem(_ pair: (Int, List<T>)) -> List<T> {
        return pair.1
    }
    func lengthItemPairs(_ list: List<List<T>>) -> List<(Int, List<T>)> {
//        let len = list.length
//        let (matches, rest) = list.span({$0.length == len})
        return list.mapList({(ls: List<T>) in (ls.length, ls)})
    }
    let lengthed = lengthItemPairs(list)
    let frequencied = freqOfLength(lengthed)
    let sorted = sortByFreq(frequencied)
    return sorted.mapList(fromPairToItem)
}

//more generic list sort, with a fn to evaluate what to sort by
func listSort<T, R:Comparable>(list: List<T>, by fn: @escaping (T) -> R) -> List<T> {
    let value = list.value!
    let nextItem = list.nextItem
    let head = List<T>(value)!
    guard let next = nextItem else { return head }
    let check = fn(value)
    let lessThanCheck: (T) -> Bool = { fn($0) < check }
    let left = next.filterList(lessThanCheck)
    let right = next.filterList({ !lessThanCheck($0) })
    if left == nil && right == nil { return head }
    if left == nil { return head + listSort(list: right!, by: fn) }
    if right == nil { return listSort(list: left!, by: fn) + head }
    return listSort(list: left!, by: fn) + head + listSort(list: right!, by: fn)
}

extension List where T:Equatable {
    func listContains(_ elem: T) -> Bool {
        if value == elem { return true }
        if nextItem == nil { return false }
        return nextItem!.listContains(elem)
    }
}

//====================================================================================
//  Section 2: Arithmetic
//P31 (**) Determine whether a given integer number is prime.
extension Int {
    func isPrime() -> Bool {
        let n = self
        guard n > 1 else { return false }
        guard n != 2 else { return true }
        return Array(2..<(n-1)).all({n % $0 != 0})
    }
}

extension Array {
    func all(_ predicate: (Element) -> Bool) -> Bool {
        //return self.filter(predicate).count == self.count
        for x in self {
            if !predicate(x) { return false }
        }
        return true
    }
    func any(_ predicate: (Element) -> Bool) -> Bool {
        //return self.filter(predicate).count > 0
        for x in self {
            if predicate(x) { return true }
        }
        return false
    }
}

//P32 (**) Determine the greatest common divisor of two positive integer numbers.
extension Int {
    static func gcd(first: Int, second: Int) -> Int {
        if second == 0 { return abs(first) }
        return gcd(first: second, second: first % second)
    }
}

//P33 (*) Determine whether two positive integer numbers are coprime.
extension Int {
    func isCoprimeTo(_ other: Int) -> Bool {
        return Int.gcd(first: self, second: other) == 1
    }
}

//P34 (**) Calculate Euler’s totient function phi(m).
//the count of all numbers that are coprime to m and <= m
extension Int {
    var totient: Int {
        return Array(1...self).filter({$0.isCoprimeTo(self)}).count
    }
}

//P35 (**) Determine the prime factors of a given positive integer.
extension Int {
    //note instead of checking 2...self, we reduce the set because any number between 
    //half of self and self can't be a prime factor of self
    var primeFactors: List<Int>? {
        func pf(_ n: Int) -> List<Int>? {
            guard n > 1 else { return nil }
            guard let prime = primes(upTo: n)
                .drop(count: 1)?
                .filterList({$0.isFactor(of: n)})?.value else {
                    return nil
            }
            return List(prime) + pf(n / prime)
        }
        return pf(self)
    }
    
    func isFactor(of x: Int) -> Bool {
        return x % self == 0
    }

    //I ended up not using these but perhaps they will be useful in the future
    func isEven(_ x: Int) -> Bool {
        return self % 2 == 0
    }
    func isOdd(_ x: Int) -> Bool {
        return !isEven(x)
    }
    
    func sqrtFloor() -> Int {
        let f = Float(self)
        return Int(floor(sqrt(f)))
    }
    
}

func primes(upTo max: Int) -> List<Int> {
    guard max > 1 else { return List(1) }
    return primes(upTo: max - 1) + (max.isPrime() ? List(max) : nil)
}


//P36 (**) Determine the prime factors of a given positive integer - Part 2.
extension Int {
    var primeFactorMultiplicity: List<(Int, Int)>? {
        return self.primeFactors?.pack().mapList({($0.value,$0.length)})
    }
    
    //skipping for now because it appears to be really difficult to do without
    //mutating a dictionary
//    var primeFactorMultiplicityDict: Dictionary<Int, Int> {
//        
//    }
}

//P37 (**) Calculate Euler’s totient function phi(m) (improved).
//if pn is a prime factor and mn is its multiplicity
//phi(m) = (p1-1)*p1^(m1-1) * (p2-1)*p2^(m2-1) * (p3-1)*p3^(m3-1) * …
extension Int {
    var totientImproved: Int {
        guard let pfs = self.primeFactorMultiplicity else { return 0 }
        return pfs.foldr(start: 1, reducer: { (r: Int?, pair: (Int,Int)) -> Int in
            return r! * (pair.0 - 1) * Int(powf(Float(pair.0), Float(pair.1 - 1)))
        })
    }
    var totientImproved2: Int {
        guard let pfs = self.primeFactorMultiplicity else { return 0 }
        return product(list: pfs.mapList({(p,c) in (p-1) * Int(pow(Double(p), Double(c-1))) }))
    }
}

func product(list: List<Int>) -> Int {
    guard let next = list.nextItem else { return list.value }
    return list.value * product(list: next)
}

//P39 (*) A linked list of prime numbers.
extension Int {
    static func listPrimesInRange(_ range: CountableClosedRange<Int>) -> List<Int>? {
        return List(Array(range)).filterList({$0.isPrime()})
    }
}

//P40 (**) Goldbach’s conjecture.
extension Int {
    func goldbach() -> (Int, Int) {
        let ps = primes(upTo: self)
        let rs = ps.reverse()
        func match(_ xs: List<Int>, _ ys: List<Int>) -> (Int, Int) {
            let x = xs.value!, y = ys.value!
            func nextMatch() -> (Int, Int) {
                if xs.nextItem != nil { return match(xs.nextItem!, ys) }
                if ys.nextItem != nil { return match(xs, ys.nextItem!) }
                return (0,0)    //we hopefully never get here
            }
            guard x + y == self else { return nextMatch() }
            return (x, y)
        }
        return match(ps, rs)
    }
}
