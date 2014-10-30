//
//  GameScene.swift
//  ShittyGame
//
//  Created by Emil Jönsson on 28/10/14.
//  Copyright (c) 2014 Reform Act. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var sceneWidth:CGFloat = 0
    var sceneHeight:CGFloat = 0
    var timeSinceLastShip = 0
    var spriteList:[SKSpriteNode] = []
    var spriteTimeList:[Int] = []
    var scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Medium")
    var timeLabel = SKLabelNode(fontNamed:"AvenirNext-Medium")
    var highScoreLabel = SKLabelNode(fontNamed:"AvenirNext-Medium")
    var gameOverLabel = SKLabelNode(fontNamed:"AvenirNext-Medium")
    var score:Int = 0
    var possible:Int = 0
    var time:Int = 0
    var timeOfGameStart = 0
    var highScore:Int = 0
    var timePerLevel = 10
    var gamePlaying = true
    var background:SKSpriteNode!
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        highScore = readHighScore()
        
        background = SKSpriteNode(imageNamed: "space.png")
        self.addChild(background)
        
        sceneWidth = UIScreen.mainScreen().bounds.width
        sceneHeight = UIScreen.mainScreen().bounds.height
        self.size = CGSize(width: sceneWidth, height: sceneHeight)
        
        scoreLabel.text = "Score: "
        scoreLabel.fontSize = 30
        scoreLabel.position = CGPoint(x: Int(sceneWidth/2), y: Int(sceneHeight) - 35 )
        self.addChild(scoreLabel)
        
        timeLabel.position = CGPoint(x: Int(sceneWidth/2), y: 30)
        timeLabel.fontSize = 30
        timeLabel.text = "Time Left: \(timePerLevel)"
        self.addChild(timeLabel)
        
        highScoreLabel.position = CGPoint(x: Int(sceneWidth/2), y: Int(sceneHeight) - 65)
        highScoreLabel.fontSize = 20
        highScoreLabel.text = "Highscore: \(highScore)"
        self.addChild(highScoreLabel)
        
        gameOverLabel.position = CGPoint(x: Int(sceneWidth/2), y: Int(sceneHeight/2))
        gameOverLabel.fontSize = 40
        gameOverLabel.text = "Game Over"
        
        timeOfGameStart = Int(NSDate().timeIntervalSince1970)
        
        createBackground()
        println(UIScreen.mainScreen().nativeBounds)
        
        let createShipTimer = NSTimer(timeInterval: 0.4, target:self, selector: "createShipAtRandomPos", userInfo:nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(createShipTimer, forMode:NSRunLoopCommonModes)
    }
    
    func startGame(){
        gameOverLabel.removeFromParent()
        self.addChild(timeLabel)
        self.addChild(background)
        scoreLabel.text = "Score: \(score)"
        gamePlaying = true
        timeOfGameStart = Int(NSDate().timeIntervalSince1970)
    }

    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let viewLoc = touch.locationInView(self.view)
            
            var touchedObject = self.nodeAtPoint(touch.locationInNode(self))
            
            println(location)
            println(viewLoc)
            
            println(touchedObject)
            var spritesToRemove:[Int] = []
            if(touchedObject is SKSpriteNode && gamePlaying == true){
                println("ship!")
                for var index = 0; index < spriteList.count; index++ {
                    var sprite = spriteList[index]
                    if(touchedObject == sprite){
                        sprite.removeFromParent()
                        spritesToRemove.append(index)
                        score++
                        updateText()
                    }
                }
            }
            for index in spritesToRemove {
                spriteList.removeAtIndex(index)
                spriteTimeList.removeAtIndex(index)
            }
            
            if(gamePlaying == false && timeWhenGameOver + 1 < Int(NSDate().timeIntervalSince1970)){
                startGame()
            }
            
            /*
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            sprite.xScale = 0.2
            sprite.yScale = 0.2
            sprite.position = location
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)*/
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        
        let timeNow = Int(NSDate().timeIntervalSince1970)
        let bonusTime = timePerLevel * (1 + (score/20))
        let timeLeft = timeOfGameStart+bonusTime - timeNow
        timeLabel.text = "Time Left: \(timeLeft)"
        if(timeLeft <= 0 && gamePlaying){
            gameOver()
        }
        
        var spritesToRemove:[Int] = []
        for var index = 0; index < spriteTimeList.count;index++ {
            let spriteTime = spriteTimeList[index]
            if(timeNow - spriteTime >= 3){
                spritesToRemove.append(index)
            }
        }
        for spriteIndex in spritesToRemove {
            let sprite:SKSpriteNode = spriteList[spriteIndex]
            sprite.removeFromParent()
            spriteTimeList.removeAtIndex(spriteIndex)
            spriteList.removeAtIndex(spriteIndex)
        }
    }
    
    func createBackground(){
        self.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    func createShipAtRandomPos(){
        if(!gamePlaying){
            return
        }
        possible++
        let sprite = SKSpriteNode(imageNamed:"Spaceship")
        sprite.xScale = 0
        sprite.yScale = 0
        var xpos = getRandomXonScreen(padding: 60)
        var ypos = getRandomYonScreen(padding: 60)
        sprite.position = CGPoint(x: xpos, y: ypos)
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration: 1)
        sprite.runAction(SKAction.repeatActionForever(action))
        let zoomAnim = SKAction.scaleXTo(0.2, duration: 0.2)
        let zoomAnimy = SKAction.scaleYTo(0.2, duration: 0.2)
        let bundle = SKAction.group([zoomAnim,zoomAnimy])
        let animMove = SKAction.moveTo(CGPoint(x: getRandomXonScreen(),y:getRandomYonScreen()), duration: 1.5)
        let animZoomOut = SKAction.scaleTo(0, duration: 0.2)
        let sequence = SKAction.sequence([bundle,animMove,animZoomOut])
        sprite.runAction(sequence)
        self.addChild(sprite)
        spriteList.append(sprite)
        spriteTimeList.append(Int(NSDate().timeIntervalSince1970))
        updateText()
    }
    
    func getRandomXonScreen(padding:CGFloat=60) -> CGFloat{
        return padding + (sceneWidth-padding*2) * Util.random()
    }
    
    func getRandomYonScreen(padding:CGFloat=60) -> CGFloat{
        return padding + (sceneHeight-padding*2) * Util.random()
    }
    
    
    func updateText(){
        scoreLabel.text = "Score: \(score)"
    }
    
    var timeWhenGameOver:Int!
    func gameOver(){
        println("gameover")
        gamePlaying = false
        timeWhenGameOver = Int(NSDate().timeIntervalSince1970)
        if(score > highScore){
            highScore = score
            highScoreLabel.text = "Highscore: \(highScore)"
            saveHighScore()
        }
        removeAllShips()
        timeSinceLastShip = 0
        spriteList = []
        spriteTimeList = []
        score = 0
        possible = 0
        time = 0
        gamePlaying = false
        background.removeFromParent()
        self.addChild(gameOverLabel)
        timeLabel.removeFromParent()
    }
    
    func removeAllShips(){
        for sprite:SKSpriteNode in spriteList {
            sprite.removeFromParent()
        }
    }
    
    func readHighScore() -> Int{
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = dirs[0].stringByAppendingPathComponent( "score.txt")
            if let text2 = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil) {
                if(text2.toInt() > 0){
                    println("highscore: \(highScore)")
                    return text2.toInt()!
                }
            }
        }
        return 0
    }
    
    func saveHighScore(){
        if let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as?  [String] {
            let path = dirs[0].stringByAppendingPathComponent( "score.txt")
            let text = String(highScore)
            //writing
            text.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        }
    }
}
