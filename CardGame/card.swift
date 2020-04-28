//
//  card.swift
//  CardGame
//
//  Created by kerollos nabil on 3/22/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import Foundation


struct Card : CustomStringConvertible{
    var description: String{
        return "\(sute) \(ranc)"
    }
    
    var sute:Sute
    var ranc:Ranc
    
    enum Sute:String,CustomStringConvertible {
        var description: String {
            return self.rawValue
        }
        
        case hart = "♥️"
        case clup = "♣️"
        case spade = "♠️"
        case diamond = "♦️"
        static var all: [Sute]{
            return [Sute.spade, .hart, .diamond, .clup]
        }
    }
    enum Ranc:CustomStringConvertible {
        
        
        case ace
        case face(String)
        case number(numberOfPips:Int)
        var getOrder:Int {
            switch self {
            case .ace:return 1
            case .number(let number): return number
            case .face(let fc) where fc=="J" : return 11
            case .face(let fc) where fc=="Q" : return 12
            case .face(let fc) where fc=="K" : return 13
            
            default : return 0
                
            }
        }
        static var all: [Ranc] {
            var allRancs = [Ranc.ace]
            for num in 2...10{
                allRancs.append(Ranc.number(numberOfPips: num))
            }
            allRancs+=[Ranc.face("J"), .face("Q"), .face("K")]
            return allRancs
        }
        var description: String {
            switch self {
            case .ace: return "A"
            case .number(let num): return "\(num)"
            case .face(let fc): return fc
            }
            
        }
    }
    
}
