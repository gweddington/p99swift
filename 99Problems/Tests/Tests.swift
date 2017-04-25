//
//  Tests.swift
//  Tests
//
//  Created by Greg Weddington on 4/18/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import XCTest

class Tests: XCTestCase {
    let theList: List<Int> = List(1, 1, 2, 3, 5, 8)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //P01 - find the last element of a list
    func testP01() {
        XCTAssertEqual(theList.last, 8)
    }
    
    //P02 - find the pennultimate element of a list
    func testP02() {
        XCTAssertEqual(theList.pennultimate, 5)
    }
    
    //P03 - find the kth element of a list
    func testP03() {
        XCTAssertEqual(theList[2], 2)
    }
    
    //P04 - Find the number of elements of a linked list.
    func testP04() {
        XCTAssertEqual(theList.length, 6)
    }
    
    //P05 - Reverse a linked list.
    func testP05() {
        XCTAssertEqual(theList.reverse(), List(8, 5, 3, 2, 1, 1)!)
    }
    
    //P06 - Find out whether a linked list is a palindrome.
    func testP06() {
        XCTAssert(List(1, 2, 3, 2, 1).isPalindrome())
        XCTAssertFalse(theList.isPalindrome())
    }
    
    
    //P07 - Flatten a nested linked list structure.
    func testP07() {
        let list = List<Any>(List<Any>(1, 1), 2, List<Any>(3, List<Any>(5, 8)))!
        XCTAssertEqual(list.flatten(), List<Any>(1, 1, 2, 3, 5, 8))
    }
    
    //P08 - Eliminate consecutive duplicates of linked list elements.
    func testP08() {
        let list = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let expected = List("a", "b", "c", "a", "d", "e")!
        let actual = list.compress()
        XCTAssertEqual(actual, expected)
    }
    
    //P09 - Pack consecutive duplicates of linked list elements into sub linked lists.
    func testP09() {
        let list = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let expected = List(List("a", "a", "a", "a")!, List("b")!, List("c", "c")!, List("a", "a")!, List("d")!, List("e", "e", "e", "e")!)!
        let actual = list.pack()
        XCTAssertEqual(actual, expected)
    }
    
    //P10 - Run-length encoding of a linked list.
    func testP10() {
        let list = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let expected = List((4, "a"), (1, "b"), (2, "c"), (2, "a"), (1, "d"), (4, "e"))!
        let actual = list.encode()
        XCTAssertEqual(actual, expected)
    }
    
    //P11 - Modified run-length encoding.
    func testP11() {
        let list = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let expected = List<Any>((4, "a"), "b", (2, "c"), (2, "a"), "d", (4, "e"))!
        let actual = list.encodeModified()
        XCTAssertEqual(actual, expected)
    }
    
    //P12 - Decode a run-length encoded linked list.
    func testP12() {
        let list = List((4, "a"), (1, "b"), (2, "c"), (2, "a"), (1, "d"), (4, "e"))!
        let expected = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let actual = list.decode()
        XCTAssertEqual(actual, expected)
        
        let actual2 = decode(list: list as List<EncodedPair>)
        XCTAssertEqual(actual2, expected)
    }
    
    //P13 - Run-length encoding of a linked list (direct solution).
    func testP13() {
        let list = List("a", "a", "a", "a", "b", "c", "c", "a", "a", "d", "e", "e", "e", "e")!
        let expected = List((4, "a"), (1, "b"), (2, "c"), (2, "a"), (1, "d"), (4, "e"))!
        let actual = list.encodeDirect()
        XCTAssertEqual(actual, expected)
    }
    
    //P14 - Duplicate the elements of a linked list.
    func testP14() {
        XCTAssertEqual(theList.duplicate(), List(1, 1, 1, 1, 2, 2, 3, 3, 5, 5, 8, 8))
        XCTAssertEqual(List("a","b","c","d").duplicate(), List("a", "a", "b", "b", "c", "c", "d", "d"))
    }
    
    //P15 - Duplicate the elements of a linked list a given number of times.
    func testP15() {
        XCTAssertEqual(theList.duplicate(times: 3), List(1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 5, 5, 5, 8, 8, 8))
        XCTAssertEqual(theList.duplicate(times: 4), theList.duplicateAlt(times: 4))
    }
    
    //P16 - Drop every Nth element from a linked list.
    func testP16() {
        let list = List("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k")!
        let expected = List("a", "b", "d", "e", "g", "h", "j", "k")!
        let actual = list.drop(every: 3)
        XCTAssertEqual(actual, expected)
        
        //try alt version
        XCTAssertEqual(list.dropAlt(every: 3), expected)
    }
    
    //P17 - Split a linked list into two parts.
    func testP17() {
        let list = List("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k")!
        let actual = list.split(at: 3)
        let expected = (left: List("a", "b", "c")!, right: List("d", "e", "f", "g", "h", "i", "j", "k")!)
        XCTAssertEqual(actual.left, expected.left)
        XCTAssertEqual(actual.right, expected.right)
    }
    
    //P18 - Extract a slice from a linked list.
    func testP18() {
        let list = List("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k")!
        let actual = list.slice(3, 7)
        let expected = List("d", "e", "f", "g")!
        XCTAssertEqual(actual, expected)
        
        XCTAssertEqual(list.sliceAlt(3, 7), expected)
    }
    
    //P19 (**) Rotate a list N places to the left.
    func testP19() {
        let list = List("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k")!
        let actual = list.rotate(amount: 3)
        let expected = List("d", "e", "f", "g", "h", "i", "j", "k", "a", "b", "c")!

        let actual2 = list.rotate(amount: -2)
        let expected2 = List("j", "k", "a", "b", "c", "d", "e", "f", "g", "h", "i")!
        
        XCTAssertEqual(actual, expected)
        XCTAssertEqual(actual2, expected2)
    }
    
    //P20 (*) Remove the Kth element from a linked list.
    func testP20() {
        let list = List("a", "b", "c", "d")!
        let actual = list.remove(at: 1)
        let expected = (rest: List("a", "c", "d"), removed: "b")
        XCTAssertEqual(actual.rest, expected.rest)
        XCTAssertEqual(actual.removed, expected.removed)
        
        //what if we only have 1 item in the list?
        let actual2 = List(1)!.remove(at: 0)
        XCTAssertNil(actual2.rest)
        XCTAssertEqual(actual2.removed, 1)
        
        //try alt solution
        XCTAssertEqual(list.removeAlt(at: 1).rest, expected.rest)
        XCTAssertEqual(list.removeAlt(at: 1).removed, expected.removed)
        
        //something's fishy with removing index 0
        XCTAssertEqual(List(1,2,3).remove(at: 0).rest, List(2,3))
        XCTAssertEqual(List(1,2,3).removeAlt(at: 0).rest, List(2,3))
    }
    
    //P21 - Insert an element at a given position into a linked list.
    func testP21() {
        let list = List("a", "b", "c", "d")!
        let actual = list.insert(at: 1, value: "new")
        let expected = List("a", "new", "b", "c", "d")!
        XCTAssertEqual(actual, expected)
    }
    
    //P22 (*) Create a linked list containing all integers within a given range.
    func testP22() {
        XCTAssertEqual(List<Any>.range(4, 9), List(4, 5, 6, 7, 8, 9)!)
    }
    
    //P23 (**) Extract a given number of randomly selected elements from a linked list.
    func testP23() {
        let list = List("a", "b", "c", "d", "e", "f", "g", "h")!
        var indices = [4,3,0]
        let actual = list.randomSelect(amount: 3) { () in
            return indices.removeFirst()
        }
        //how does one assert randomness? Instead of the requested fn, I will write one that accepts
        //a fn that provides the random indices
        let expected = List("e","d","a")!
        XCTAssertEqual(actual, expected)
    }
    
    //P24 (*) Lotto: Draw N different random numbers from the set 1..M.
    func testP24() {
        var nums = [23, 1, 17, 33, 21, 37]
        let expected = List(nums)!
        let actual = List<Any>.lotto(6, 49) { () in
            return nums.removeFirst()
        }
        XCTAssertEqual(actual, expected)
        
        //test if it respects the given maximum
        let actual2 = List<Any>.lotto(7, 2) { () in
            return 3
        }
        //we don't care about what the values are just that they are all less than or equal to 2
        let greaterThan2 = actual2.filter({$0 > 2})
        XCTAssertNil(greaterThan2)
    }
    
    //P25 (*) Generate a random permutation of the elements of a linked list.
    func testP25() {
        let expected = List("b", "a", "d", "c", "f", "e")
        let actual = List("a", "b", "c", "d", "e", "f").randomPermute() { (max) in
            return max % 2
        }
        XCTAssertEqual(actual, expected)
    }
    
    //P26 (**) Generate the combinations of K distinct objects chosen from the N elements of a linked list.
    func testP26() {
        let actual = List("a", "b", "c")!.combinations(group: 2)
        let expected = List(List("a", "b")!, List("a", "c")!, List("b", "c")!)!
        XCTAssertEqual(actual, expected)

        let actual2 = List("a", "b", "c", "d")!.combinations(group: 3)
        let expected2 = List(List("a", "b", "c")!, List("a", "b", "d")!, List("a", "c", "d")!,                        List("b", "c", "d")!)!
        XCTAssertEqual(actual2, expected2)
        
        //binomial coefficient should be n! / ((n-k)! * k!)
        //so... 4! / (4-2)! * 2! = 6
        XCTAssertEqual(List(Array(1...4))!.combinations(group: 2).length, 6)
        //and.... 12! / (10! * 2!) = 66
        XCTAssertEqual(List(Array(1...12))!.combinations(group: 2).length, 66)
    }
    
    //P26B (**) Generate the permutations of K distinct objects chosen from the N elements of a linked list.
    func testP26B() {
        let actual = List("a", "b", "c").permutations(group: 2)
        //because permutations does not return this in any particular order, just ensure it has all the values we expect
        XCTAssert(actual.contains(List("a", "b")!))
        XCTAssert(actual.contains(List("a", "c")!))
        XCTAssert(actual.contains(List("b", "a")!))
        XCTAssert(actual.contains(List("b", "c")!))
        XCTAssert(actual.contains(List("c", "a")!))
        XCTAssert(actual.contains(List("c", "b")!))
        XCTAssertEqual(actual.length, 6)
    }
    
    //P27 (**) Group the elements of a set into disjoint subsets.
    func testP27() {
        //let list = List("Aldo", "Beat", "Carla", "David", "Evi", "Flip", "Gary", "Hugo", "Ida")!
        //let actual = list.group3()
        //how can I test this? hell I can't even figure out how to do it
        //XCTAssertEqual(actual?.length, 1260) // 9! / 2!*3!*4! = 1260
        print("Skipping P27 because I wasn't smart enough to figure it out :(")
    }
    
    //P28 (**) Sorting a linked list of linked lists according to length of sublists.
    func testP28() {
        let list = List(List("a", "b", "c")!, List("d", "e")!, List("f", "g", "h")!, List("d", "e")!, List("i", "j", "k", "l")!, List("m", "n")!, List("o")!)!
        let actual = lsort(list: list)
        let expected = List(List("o")!, List("d", "e")!, List("d", "e")!, List("m", "n")!, List("a", "b", "c")!, List("f", "g", "h")!, List("i", "j", "k", "l")!)!
        XCTAssertEqual(actual, expected)
    }
    
    //P28B (**) Sorting a linked list of linked lists according to their length frequency.
    func testP28B() {
        let list = List(List("a", "b", "c")!, List("d", "e")!, List("f", "g", "h")!, List("d", "e")!, List("i", "j", "k", "l")!, List("m", "n")!, List("o")!)!
        let actual = lsortFreq(list: list)
        let expected = List(List("i", "j", "k", "l")!, List("o")!, List("a", "b", "c")!, List("f", "g", "h")!, List("d", "e")!, List("d", "e")!, List("m", "n")!)!
        XCTAssertEqual(actual, expected)
    }
}
