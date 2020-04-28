//
//  playingCardDeck.swift
//  CardGame
//
//  Created by kerollos nabil on 3/22/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import Foundation

struct PlayingCardDeck {
    private(set) var Deck = [Card]()
    
    init() {
        for sute in Card.Sute.all{
            for ranc in Card.Ranc.all {
                Deck.append(Card(sute: sute, ranc: ranc))
            }
        }
    }
    mutating func draw() -> Card?{
        if Deck.count > 0 {
            return Deck.remove(at: Deck.count.arc4number)
        }else {return nil}
        
    }
}
extension Int{
    var arc4number: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
        
    }
    
}
