//
//  GameSprite.swift
//  ShittyGame
//
//  Created by Emil Jönsson on 30/10/14.
//  Copyright (c) 2014 Reform Act. All rights reserved.
//

import SpriteKit

class GameSprite  {
    var animating:Bool = false
    var sprite:SKSpriteNode
    
    init(imageName:String){
        sprite = SKSpriteNode(imageNamed:imageName)
        sprite.xScale = 0
        sprite.yScale = 0
    }
    
    class func show(animationtime:CGFloat = 0.5) {
        let zoomAnim = SKAction.scaleXTo(0.2, duration: 0.2)
        let zoomAnimy = SKAction.scaleYTo(0.2, duration: 0.2)
        let sequence = SKAction.sequence([zoomAnim,zoomAnimy])
        
    }
    
    class func showComplete(){
        
    }
    
    class func hide(time:CGFloat = 0.5) {
        
    }
    class func hideComplete(){
        
    }
}