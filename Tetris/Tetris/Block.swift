//
//  Block.swift
//  Tetris
//
//  Created by Joey on 4/17/16.
//  Copyright © 2016 Joey. All rights reserved.
//

import Foundation

struct Block {
    var x: Int
    var y: Int
    var color: Int
    var description: String{
        return "Block[x=\(x), y=\(y), color=\(color)]"
    }
    
}