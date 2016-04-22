//
//  DBMZGloble.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/22.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

typealias DBMZColor = UIColor.LocalColorName

extension UIColor{
    enum LocalColorName:String {
        case barTintColor = "#1A1A1A"  /*navigationbar 的颜色*/
        case tabbarSelectedTextColor = "#68BB1E"
        case viewBackgroundColor = "#E7EBEE"
    }
    
    convenience init(colorNamed name:LocalColorName) {
        self.init(rgba:name.rawValimport UIColor_Hex_Swiftue)
    }
}