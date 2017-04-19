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
}
