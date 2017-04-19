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
}
