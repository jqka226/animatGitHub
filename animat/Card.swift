//
//  Card.swift
//  animat
//
//  Created by 潘政杰 on 2020/1/7.
//  Copyright © 2020 潘政杰. All rights reserved.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier: Int
    
    static var identifierFactory = 0
    
    static func getIdentifier() -> Int{
        identifierFactory += 1
        return identifierFactory
    }
    init() {
        self.identifier = Card.getIdentifier()
    }
}
