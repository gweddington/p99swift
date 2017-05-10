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
        let greaterThan2 = actual2.filterList({$0 > 2})
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
        XCTAssert(actual.listContains(List("a", "b")!))
        XCTAssert(actual.listContains(List("a", "c")!))
        XCTAssert(actual.listContains(List("b", "a")!))
        XCTAssert(actual.listContains(List("b", "c")!))
        XCTAssert(actual.listContains(List("c", "a")!))
        XCTAssert(actual.listContains(List("c", "b")!))
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
    
    //Section 2: Arithmetic
    //P31 (**) Determine whether a given integer number is prime.
    func testP31() {
        XCTAssert(7.isPrime())
        XCTAssertFalse(8.isPrime())
    }
    
    //P32 (**) Determine the greatest common divisor of two positive integer numbers.
    func testP32() {
        XCTAssertEqual(Int.gcd(first: 36, second: 63), 9)
    }
    
    //P33 (*) Determine whether two positive integer numbers are coprime.
    func testP33() {
        XCTAssert(35.isCoprimeTo(64))
        XCTAssertFalse(35.isCoprimeTo(65))
    }
    
    //P34 (**) Calculate Euler’s totient function phi(m).
    func testP34() {
        XCTAssertEqual(10.totient, 4)
    }
    
    //P35 (**) Determine the prime factors of a given positive integer.
    func testP35() {
        XCTAssertEqual(315.primeFactors, List(3, 3, 5, 7))
    }
    
    //P36 (**) Determine the prime factors of a given positive integer - Part 2.
    func testP36() {
        let actual = 315.primeFactorMultiplicity
        let expected = List((3, 2), (5, 1), (7, 1))
        XCTAssertEqual(actual, expected)
    }
    
    //P37 (**) Calculate Euler’s totient function phi(m) (improved).
    func testP37() {
        XCTAssertEqual(10.totientImproved, 4)
        //fwiw, the improved version is slower, at least for small numbers!
        for i in 2...50 {
            XCTAssertEqual(i.totientImproved, i.totient)
        }
    }
    
    func testP38Totient() {
        measure {
            print(10090.totient)
        }
    }
    //Don't do this! It is terribly slow
//    func testP38TotientImproved() {
//        measure {
//            print(10090.totientImproved)
//        }
//    }
    
    //P39 (*) A linked list of prime numbers.
    func testP39() {
        XCTAssertEqual(Int.listPrimesInRange(7...31), List(7, 11, 13, 17, 19, 23, 29, 31))
    }
    
    
    //P40 (**) Goldbach’s conjecture.
    func testP40() {
        let actual = 28.goldbach()!
        XCTAssertEqual(actual.0, 5)
        XCTAssertEqual(actual.1, 23)
        let a2 = 12.goldbach()!
        XCTAssertEqual(a2.0, 5)
        XCTAssertEqual(a2.1, 7)
    }
    
    //P41 (**) A list of Goldbach compositions.
    func testP41() {
        let actual = Int.goldbachList(9...20)
        let expected = List("10 = 3 + 7",
                            "12 = 5 + 7",
                            "14 = 3 + 11",
                            "16 = 3 + 13",
                            "18 = 5 + 13",
                            "20 = 3 + 17")
        XCTAssertEqual(actual, expected)
        
        print("skipping goldbachListLimited because it is slow to exec")
        //let a2 = Int.goldbachListLimited(1...2000, minValue: 50)
        //let e2 = List("992 = 73 + 919",
        //              "1382 = 61 + 1321",
        //              "1856 = 67 + 1789",
        //              "1928 = 61 + 1867")
        //XCTAssertEqual(a2, e2)
    }
    
    //P46 (**) Truth tables for logical expressions.
    func testP46() {
        XCTAssertTrue(and(a: true, b: true))
        XCTAssertFalse(and(a: true, b: false))
        XCTAssertFalse(and(a: false, b: true))

        XCTAssertTrue(or(a: true, b: false))
        XCTAssertTrue(or(a: false, b: true))
        XCTAssertFalse(or(a: false, b: false))
        
        XCTAssertTrue(nand(a: false, b: true))
        XCTAssertTrue(nand(a: true, b: false))
        XCTAssertFalse(nand(a: true, b: true))

        XCTAssertFalse(nor(a: true, b: false))
        XCTAssertFalse(nor(a: false, b: true))
        XCTAssertTrue(nor(a: false, b: false))

        XCTAssertTrue(xor(a: true, b: false))
        XCTAssertTrue(xor(a: false, b: true))
        XCTAssertFalse(xor(a: false, b: false))
        XCTAssertFalse(xor(a: true, b: true))

        XCTAssertFalse(impl(a: true, b: false))
        XCTAssertTrue(impl(a: false, b: true))
        XCTAssertTrue(impl(a: false, b: false))
        XCTAssertTrue(impl(a: true, b: true))

        XCTAssertFalse(equ(a: true, b: false))
        XCTAssertFalse(equ(a: false, b: true))
        XCTAssertTrue(equ(a: false, b: false))
        XCTAssertTrue(equ(a: true, b: true))

        let expected = List(
            List(true,  true,  true )!,
            List(true,  false, true )!,
            List(false, true,  false)!,
            List(false, false, false)!
        )!
        XCTAssertEqual(table(expression: { and(a: $0, b: or(a: $0, b: $1)) }), expected)
    }
    
    //P47 (*) Truth tables for logical expressions - Part 2.
    func testP47() {
        let expected = List(
            List(true,  true,  true )!,
            List(true,  false, true )!,
            List(false, true,  false)!,
            List(false, false, false)!
        )!
        XCTAssertEqual(table(expression: { $0 ∧ ($0 ∨ $1) }), expected)
    }
    
    //P48 (**) Truth tables for logical expressions - Part 3.
    func testP48() {
        let expected = List(
            List(true,  true,  true,  true )!,
            List(true,  true,  false, true )!,
            List(true,  false, true,  true )!,
            List(true,  false, false, false)!,
            List(false, true,  true,  true )!,
            List(false, true,  false, false)!,
            List(false, false, true,  true )!,
            List(false, false, false, false)!
        )!
        XCTAssertEqual(table(variables: 3, expression: { vars in vars[0] ∧ vars[1] ∨ vars[2] }), expected)
        
    }
    
    //P49 - Gray Codes
    func testP49() {
        let expected = List("000", "001", "011", "010", "110", "111", "101", "100")!
        XCTAssertEqual(gray(number: 3), expected)

    
        let expected2 = List("0000", "0001", "0011", "0010", "0110", "0111", "0101", "0100"
                            ,"1100","1101","1111","1110", "1010", "1011", "1001", "1000")!
        XCTAssertEqual(gray(number: 4), expected2)

        let gray2 = memoSingleArgFunc(fn: gray)
        XCTAssertEqual(gray(number: 1), gray2(1))
        XCTAssertEqual(gray(number: 2), gray2(2))
        XCTAssertEqual(gray(number: 3), gray2(3))
        XCTAssertEqual(gray(number: 4), gray2(4))
    }

    //with a gray number of 8, the memoized version was 3 times faster
    //I think each measure block is executed 10 times
    //this is the time for each run for one sample of 10
    //[0.069467, 0.002209, 0.002203, 0.002208, 0.002748, 0.002333, 0.002179, 0.002195, 0.001838, 0.002455]
    //notice the first one takes .07 secs and each subsequent one takes .002 secs
//    func testSpeedGray() {
//        measure {
//            print(gray(number: 8))
//        }
//        //1.016
//        //1.003
//        //1.002
//    }
//    func testSpeedGray2() {
//        let gray2 = memoSingleArgFunc(fn: gray)
//        measure {
//            print(gray2(8))
//        }
//        //0.347
//        //0.349
//        //0.371
//    }
    
    func testP50() {
        //note: we have to sort the huffman result to put the list in the same order as the
        // expected result because order is not guaranteed to be the same as it was going in
        // actually, the resulting order will be by the original int value NOT the orig string value
        // so, in contrast, I could have just adjusted the expected result order
        let actual = listSort(list: huffman(symbols: List(("a", 45), ("b", 13), ("c", 12), ("d", 16), ("e", 9), ("f", 5)))) { $0.0 }
        let expected = List(("a", "0"), ("b", "101"), ("c", "100"), ("d", "111"), ("e", "1101"), ("f", "1100"))!
        XCTAssertEqual(actual, expected)
    }
    
    //P54 (*) Completely balanced trees.
    func testP54() {
        let balanced = BinaryTree(node: "a",
                                  left: BinaryTree(node: "b"),
                                  right: BinaryTree(node: "c"))
        let unbalanced = BinaryTree(node: "x",
                                   left: BinaryTree(node: "y",
                                                    left: BinaryTree(node: "z")))
        XCTAssert(balanced.isCompletelyBalanced)
        XCTAssertFalse(unbalanced.isCompletelyBalanced)
    }
    
    //P55 (**) Construct completely balanced binary trees.
    func testP55() {
        let actual = BinaryTree.makeBalancedTrees(nodes: 4, value: "x")
        let leaf = BinaryTree(node: "x")
        let s0 = BinaryTree(node: "x",
                            left: leaf,
                            right: BinaryTree(node: "x",
                                              left: leaf,
                                              right: nil))
        let s1 = BinaryTree(node: "x",
                            left: leaf,
                            right: BinaryTree(node: "x",
                                              left: nil,
                                              right: leaf))
        let s2 = BinaryTree(node: "x",
                            left: BinaryTree(node: "x",
                                             left: leaf,
                                             right: nil),
                            right: leaf)
        let s3 = BinaryTree(node: "x",
                            left: BinaryTree(node: "x",
                                             left: nil,
                                             right: leaf),
                            right: leaf)
        XCTAssert((actual?.values().any({ $0 == s0 }))!)
        XCTAssert((actual?.values().any({ $0 == s1 }))!)
        XCTAssert((actual?.values().any({ $0 == s2 }))!)
        XCTAssert((actual?.values().any({ $0 == s3 }))!)
    }
    
    //P56 (**) Symmetric binary trees.
    func testP56() {
        let tree = BinaryTree(node: "A", left: BinaryTree(node: "B"), right: BinaryTree(node: "C"))
        let tree2 = BinaryTree(node: "A", left: BinaryTree(node: "B"), right: BinaryTree(node: "C", left: BinaryTree(node: "D")))
        XCTAssert(tree.isSymmetric)
        XCTAssertFalse(tree2.isSymmetric)
    }
}
