//
//  GameScene.swift
//  Project11
//
//  Created by Adrimi on 03/08/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let colors = ["Blue", "Cyan", "Green", "Grey", "Purple", "Red", "Yellow"]
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        addBackground()
        addScoreLabel()
        
        // conform to contact delegate
        physicsWorld.contactDelegate = self
        
        // register physics, the area of active physics is whole scene!
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        // spawn slots
        for x in 0..<5 {
            makeSlot(at: CGPoint(x: x * 256 + 128, y: 0), isGood: x % 2 == 0 ? true : false)
        }
        
        // spawn bouncers
        for x in 0...5 {
            makeBouncer(at: CGPoint(x: x * 256, y: 0))
        }
    }
    
    func addBackground() {
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
    }
    
    func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 900, y: 700)
        addChild(scoreLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // get first tap
        guard let touch = touches.first else { return }
        
        // where it was tapped (get the location)
        let location = touch.location(in: self)
        
        // create ball names
        let balls = colors.map { "ball\($0)" }
        
        // create view based on image(and alpha)
        let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? "ballBlue")
        
        // add physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
        
        // add bounciness
        ball.physicsBody?.restitution = 0.4
        
        // register view to contact delegate.
        // CollisionBitMask tells what views are desired to contact (default - everything on a scene).
        // ContactTestBitMask tells of what contact delegate will notify
        ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
        
        // relocate
        ball.position = location
        
        // name to ball
        ball.name = "ball"
        
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
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // physics to slot
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotGlow)
        addChild(slotBase)
        
        // spinnning code
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    // when contact between two object is happening, we don't know about the order of contact (is 1. body to 2. body / or 2. to 1. / both!)
    // but it is important to catch Ball collision to node there!
    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        
        // special effects!
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let noteB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: noteB)
        } else if noteB.name == "ball" {
            collision(between: noteB, object: nodeA)
        }
        
        // there is no need to support ball-to-ball contact
    }
}
