//
//  ViewController.swift
//  CardGame
//
//  Created by kerollos nabil on 3/22/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var cardDeck = PlayingCardDeck()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 1.0
        card.layer.shadowOffset = .zero
        card.layer.shadowRadius = 10.0
        card.layer.shadowPath = UIBezierPath(rect: card.bounds).cgPath
        card.layer.shouldRasterize = true
        card.layer.rasterizationScale = UIScreen.main.scale
    }

    @IBOutlet weak var cardView: CardView!{
        didSet{
            let swibe = UISwipeGestureRecognizer(target: self, action: #selector(flibCard(sender:)))
            swibe.direction = [.left, .right]
            cardView.addGestureRecognizer(swibe)
            
            let binah = UIPinchGestureRecognizer(target: cardView, action: #selector(cardView.changeRatio(sender:)) )
            cardView.addGestureRecognizer(binah)
        }
    }
    
    @IBOutlet weak var card: CardView!
    @objc func flibCard(sender: UISwipeGestureRecognizer){
        
        cardView.isFaceUp = !cardView.isFaceUp
        
    }
    
    
    @IBAction func changeCard(_ sender: UITapGestureRecognizer) {
        if let card = cardDeck.draw(){
            cardView.rank = card.ranc.getOrder
            cardView.sute = card.sute.rawValue
        }
    }
}

