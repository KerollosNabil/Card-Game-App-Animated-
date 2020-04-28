//
//  File.swift
//  CardGame
//
//  Created by kerollos nabil on 4/9/20.
//  Copyright © 2020 kerollos nabil. All rights reserved.
//

import UIKit

class CardBehabior: UIDynamicBehavior {
    lazy var collisionBehavior : UICollisionBehavior = {
        var behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    lazy var itemBehavior:UIDynamicItemBehavior = {
        var behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1.0
        behavior.allowsRotation = false
        behavior.resistance = 0
        return behavior
    }()
    private func addItemPushBehavior(_ item:UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2*CGFloat.pi) * CGFloat(Float.random(in: 0 ..< 1))
        push.magnitude = CGFloat(1) + CGFloat(2).arc4random
        push.action = {[unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    func addItem_(_ item:UIDynamicItem) {
        itemBehavior.addItem(item)
        collisionBehavior.addItem(item)
        addItemPushBehavior(item)
    }
    func removeItem_(_ item:UIDynamicItem) {
        itemBehavior.removeItem(item)
        collisionBehavior.removeItem(item)
        
    }
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    convenience init(in animator:UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
        
    }
}
