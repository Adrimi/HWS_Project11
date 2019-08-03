//
//  GameScene.swift
//  Project11
//
//  Created by Adrimi on 03/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        
        // create background
        let background = SKSpriteNode(imageNamed: "background")
        
        // set its position to center of the iPad view
        background.position = CGPoint(x: 512, y: 384)
        
        // ignore alpha value
        background.blendMode = .replace
        
        // draw behind, cause it's background
        background.zPosition = -1
        
        // register background
        addChild(background)
        
        // register physics, the area of active physics is whole scene!
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        for x in 0...5 {
            makeBouncer(at: CGPoint(x: x * 256, y: 0))
        }
        
        for x in 0...5 {
            makeSlot(at: CGPoint(x: x * 256 + 128, y: 0), isGood: x % 2 == 0 ? true : false)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get first tap
        guard let touch = touches.first else { return }
        
        // where it was tapped (get the location)
        let location = touch.location(in: self)
        
        // create view based on image(and alpha)
        let ball = SKSpriteNode(imageNamed: "ballRed")
        
        // add physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        // add bounciness
        ball.physicsBody?.restitution = 0.4
        
        // relocate
        ball.position = location
        
        // register to main view
        addChild(ball)
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // always stay in one place!
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        addChild(slotGlow)
        addChild(slotBase)
        
        // spinnning code
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
}
