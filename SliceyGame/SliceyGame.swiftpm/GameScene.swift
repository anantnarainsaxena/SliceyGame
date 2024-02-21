import SpriteKit

class GameScene: SKScene {
    
    let healthyCategory: UInt32 = 0x1 << 0
    let junkCategory: UInt32 = 0x1 << 1
    let bladeCategory: UInt32 = 0x1 << 2
    
    var slicedFoods: [SKSpriteNode] = []
    var gameOverLabel: SKLabelNode!
    var onboardingLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.5)
        physicsWorld.contactDelegate = self
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnFood), SKAction.wait(forDuration: 1.0)])))
        
        gameOverLabel = SKLabelNode(text: "Uhh oh !! \nGame Over  Better Luck next time☺️")
        gameOverLabel.fontSize = 60
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        onboardingLabel = SKLabelNode(text: "Slice the fruits, avoid the junk food")
        onboardingLabel.fontSize = 30
        onboardingLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(onboardingLabel)
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.fontSize = 24
        scoreLabel.position = CGPoint(x: size.width - 100, y: size.height - 50)
        addChild(scoreLabel)
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 3.0)
        onboardingLabel.run(SKAction.sequence([fadeOutAction, SKAction.hide()]))
    }
    

    func spawnFood() {
        let foodName: String
        let category: UInt32
        
        let randomNum = Int.random(in: 1...5) // Generate a random number to decide which food to spawn
        switch randomNum {
        case 1: // Banana
            foodName = "banana.png"
            category = healthyCategory
        case 2: // Orange
            foodName = "orange.png"
            category = healthyCategory
        case 3: // Pear
            foodName = "pear.png"
            category = healthyCategory
        case 4: // Mango
            foodName = "mango.png"
            category = healthyCategory
        case 5: // Junk food
            let junkFoods = ["burger.png", "chocolate.png", "colddrink.png"] // Add more junk food images as needed
            foodName = junkFoods.randomElement()!
            category = junkCategory
        default:
            fatalError("Unexpected random number")
        }
        
        let food = SKSpriteNode(imageNamed: foodName)
        food.name = "food" // Set the name of the food node
        food.userData = ["foodName": foodName] // Store the food name in the userData dictionary for easier comparison
        
        let scaleFactor: CGFloat = 0.2
        food.scale(to: CGSize(width: food.size.width * scaleFactor, height: food.size.height * scaleFactor))
        food.position = CGPoint(x: CGFloat.random(in: 50...size.width - 50), y: size.height + 20)
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.categoryBitMask = category
        food.physicsBody?.contactTestBitMask = bladeCategory
        addChild(food)
        
        
        let moveAction = SKAction.moveTo(y: -20, duration: 3.0)
        food.run(moveAction) {
            food.removeFromParent()
        }
    }

    
    func sliceFood(_ food: SKSpriteNode) {
        if food.name == "food" {
            guard let foodName = food.userData?["foodName"] as? String else {
                return
            }
            
            let slicedFoodName: String
            var isHealthy = false
            
            if foodName == "banana.png" || foodName == "orange.png" || foodName == "pear.png" || foodName == "mango.png" {
                slicedFoodName = "sliceFruit.png"
                isHealthy = true
            } else if foodName == "burger.png" || foodName == "chocolate.png" || foodName == "colddrink.png" {
                slicedFoodName = "sliceJunkFood.png"
            } else {
                // If food is neither healthy nor junk, return
                return
            }
            
            let slicedFood = SKSpriteNode(imageNamed: slicedFoodName)
            let scaleFactor: CGFloat = 0.2
            slicedFood.scale(to: CGSize(width: slicedFood.size.width * scaleFactor, height: slicedFood.size.height * scaleFactor))
            slicedFood.position = food.position
            addChild(slicedFood)
            
            food.removeFromParent()
            slicedFoods.append(slicedFood)
            
            if isHealthy {
                score += 1
                updateScoreLabel()
            } else {
                stopGame()
            }
            
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            let removeAction = SKAction.removeFromParent()
            slicedFood.run(SKAction.sequence([fadeOutAction, removeAction]))
        }
    }




    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let touchedNode = atPoint(location) as? SKLabelNode {
                if touchedNode.name == "restartButton" {
                    // Restart the game
                    restartGame()
                }
            }
            
            if let touchedNode = atPoint(location) as? SKSpriteNode {
                if touchedNode.name == "food" {
                    sliceFood(touchedNode)
                } else {
                    let blade = SKSpriteNode(imageNamed: "knife.png")
                    let scaleFactor: CGFloat = 0.2 // Adjust this value based on your preference
                    blade.scale(to: CGSize(width: blade.size.width * scaleFactor, height: blade.size.height * scaleFactor))
                    blade.position = location
                    blade.physicsBody = SKPhysicsBody(rectangleOf: blade.size)
                    blade.physicsBody?.categoryBitMask = bladeCategory
                    addChild(blade)
                }
            }
        }
        
        onboardingLabel.isHidden = true
    }
    
    func stopGame() {
        print("Game stopped")
        
        // Show the game over label
        gameOverLabel.isHidden = false
        let fadeInAction = SKAction.fadeIn(withDuration: 1.0)
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        let sequence = SKAction.sequence([fadeInAction, fadeOutAction])
        let repeatForever = SKAction.repeatForever(sequence)
        gameOverLabel.run(repeatForever)
        
        
        if let scoreLabelBig = childNode(withName: "scoreLabelBig") {
            scoreLabelBig.removeFromParent()
        }
        
        let scoreLabelBig = SKLabelNode(text: "Score: \(score)")
        scoreLabelBig.fontSize = 48
        scoreLabelBig.fontColor = .white
        scoreLabelBig.position = CGPoint(x: size.width / 2, y: size.height / 3)
        scoreLabelBig.name = "scoreLabelBig"
        addChild(scoreLabelBig)
        
        
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.fontSize = 36
        restartButton.fontColor = .white
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 8) // Adjusted position
        restartButton.name = "restartButton"
        addChild(restartButton)
        
        
        // Stop further spawning of food
        removeAllActions()
    }
    
    func restartGame() {
        // Reset score to 0
        score = 0
        updateScoreLabel() // If you have a score label, update it here
        
        // Remove all existing food and sliced food
        for child in children {
            if child.name == "food" || child.name == "slicedFood" {
                child.removeFromParent()
            }
        }
        
        // Hide game over label and restart button
        gameOverLabel.isHidden = true
        if let restartButton = childNode(withName: "restartButton") {
            restartButton.removeFromParent()
        }
        
        // Remove score label from previous game
        if let scoreLabelBig = childNode(withName: "scoreLabelBig") {
            scoreLabelBig.removeFromParent()
        }
        
        // Resume spawning food
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnFood), SKAction.wait(forDuration: 1.0)])))
    }



    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if let blade = childNode(withName: "blade") {
                blade.position = location
            }
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == healthyCategory && contact.bodyB.categoryBitMask == bladeCategory) ||
            (contact.bodyA.categoryBitMask == bladeCategory && contact.bodyB.categoryBitMask == healthyCategory) {
            if let foodNode = contact.bodyA.node as? SKSpriteNode {
                sliceFood(foodNode)
            } else if let foodNode = contact.bodyB.node as? SKSpriteNode {
                sliceFood(foodNode)
            }
        }
    }
}
