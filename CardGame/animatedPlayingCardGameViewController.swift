//
//  animatedPlayingCardGameViewController.swift
//  CardGame
//
//  Created by kerollos nabil on 4/5/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import UIKit

class animatedPlayingCardGameViewController: UIViewController {
    
    let numberOfCards = 12
    let aspectC = CGFloat(3.5 / 2.25)
    let cardsToBackground = CGFloat(0.55)
    var cards = [CardView] ()
    var dick = PlayingCardDeck()
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehabior(in: self.animator)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        for _ in 1...(numberOfCards/2) {
            let card = CardView()
            let card2 = CardView()
            
            
            let cardDesc = dick.draw()
            card.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            card.rank = cardDesc?.ranc.getOrder ?? 0
            card.sute = cardDesc?.sute.rawValue ?? "?"
            card.isFaceUp = false
            card2.isFaceUp = false
            card2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            card2.rank = cardDesc?.ranc.getOrder ?? 0
            card2.sute = cardDesc?.sute.rawValue ?? "?"
            card2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipTheCard(sender:))))
            card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipTheCard(sender:))))
            

            cards += [card, card2]
        }
        cards = cards.shuffled()
        updateViewWith(numberOfViws: CGFloat(numberOfCards), viewSize: view.bounds.size)
        for card in cards {
            view.addSubview(card)

            cardBehavior.addItem_(card)
            
            
        }
        
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateViewWith(numberOfViws: CGFloat(numberOfCards), viewSize: size)
    }
    private var faceUpCards: [CardView]{
        return cards.filter { (card) in
            return card.isFaceUp && !card.isHidden
        }
    }
    @objc func flipTheCard(sender:UITapGestureRecognizer){
        switch sender.state {
        case .ended:
            if let cardView = sender.view as? CardView{
                cardBehavior.removeItem_(cardView)
                UIView.transition(with: cardView,
                                  duration: 0.8,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    cardView.isFaceUp = !cardView.isFaceUp
                                    
                },completion: {
                    (finished) in
                    if (self.faceUpCards.count == 2){
                        if self.faceUpCards[0].rank == self.faceUpCards[1].rank && self.faceUpCards[0].sute == self.faceUpCards[1].sute {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0.0,
                                options: [],
                                animations: {
                                    self.faceUpCards.forEach {(card) in
                                        card.transform = CGAffineTransform.identity.scaledBy(x: 3, y: 3)
                                        
                                        }
                            }) { (posstion) in
                                UIViewPropertyAnimator.runningPropertyAnimator(
                                    withDuration: 0.8,
                                    delay: 0.0,
                                    options: [],
                                    animations: {
                                        self.faceUpCards.forEach {(card) in
                                            card.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                            card.alpha = 0
                                            }
                                }) { (posstion) in
                                    self.faceUpCards.forEach {(card) in
                                        card.isHidden = true
                                        card.transform = .identity
                                        card.alpha = 1                                    }
                                }
                            }
                        }
                        else{
                            self.faceUpCards.forEach({(card) in
                            UIView.transition(with: card,
                                              duration: 0.8,
                                              options: [.transitionFlipFromLeft],
                                              animations: {
                                                card.isFaceUp = false
                                                
                            },completion: {(isFinished) in self.cardBehavior.addItem_(card)}
                                )
                            })
                        }
                        
                    }else {
                        self.cardBehavior.addItem_(cardView)
                    }
                    
                })
                
            }
        default:
            break
        }
    }
    
    
    
    
    
    private func updateViewWith(numberOfViws n:CGFloat, viewSize:CGSize){
        let aspectS = viewSize.width / viewSize.height
        let nx = (aspectS * aspectC * n).squareRoot().rounded()
        let ny = ceil(n/nx)
        let cardSummitionWidth = viewSize.width *  cardsToBackground
        let cardSummitionhight = viewSize.height *  cardsToBackground
        var cardWidth = cardSummitionWidth / nx
        var cardHight = cardWidth * aspectC
        
        if cardHight * ny > cardSummitionhight{
            cardHight = cardSummitionhight/ny
            cardWidth = cardHight * (1/aspectC)
        }
        
        let spacePetweenCardsWidth = (viewSize.width - cardWidth*nx)/(nx+1)
        let spacePetweenCardshight = (viewSize.height - cardHight*ny)/(ny+1)
        
        var currentPossition = CGRect(x: spacePetweenCardsWidth, y: spacePetweenCardshight, width: cardWidth, height: cardHight)
        var counter = 0
        
        for _ in 1...(Int(ny)-1) {
            for _ in 1...Int(nx) {
                cards[counter].frame = currentPossition
                currentPossition = CGRect(x: currentPossition.maxX + spacePetweenCardsWidth, y: currentPossition.minY, width: cardWidth, height: cardHight)
                counter += 1
            }
            currentPossition = CGRect(x: spacePetweenCardsWidth, y: currentPossition.maxY + spacePetweenCardshight, width: cardWidth, height: cardHight)
        }
        
        for _ in 1...Int(n-(nx*(ny-1))) {
            cards[counter].frame = currentPossition
            currentPossition = CGRect(x: currentPossition.maxX + spacePetweenCardsWidth, y: currentPossition.minY, width: cardWidth, height: cardHight)
            counter += 1
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
extension CGFloat{
    var arc4random:CGFloat{
        if self > 0{
            
            return self*CGFloat(arc4random_uniform(UInt32(self)))/CGFloat(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -self*CGFloat(arc4random_uniform(UInt32(self)))/CGFloat(arc4random_uniform(UInt32(self)))
        }else {
            return 0
        }
    }
    /*var arc4number: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
        
    }*/
    
}
