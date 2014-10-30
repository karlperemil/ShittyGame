//
//  Util.swift
//  ShittyGame
//
//  Created by Emil Jönsson on 29/10/14.
//  Copyright (c) 2014 Reform Act. All rights reserved.
//

import Foundation
import SpriteKit

class Util {
    class func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    }
}