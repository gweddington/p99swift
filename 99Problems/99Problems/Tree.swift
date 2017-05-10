//
//  Tree.swift
//  99Problems
//
//  Created by Greg Weddington on 5/9/17.
//  Copyright © 2017 Greg Weddington. All rights reserved.
//

import Foundation


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
