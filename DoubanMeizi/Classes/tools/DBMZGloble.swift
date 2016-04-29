//
//  DBMZGloble.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/22.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import Foundation
import UIColor_Hex_Swift

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

struct DBMZNavPageModel {
    let title:String!
    let url:String!
    
}

struct DBMZMainPageModel {
    let title:String!
    let imageUrl:String!
    let jumpUrl:String!
}

enum DBMZType:Int {
    case DBMZTypeAll = 0
    case DBMZTypeDaXiong = 1
    case DBMZTypeQiaoTun = 2
    case DBMZTypeHeisi = 3
    case DBMZTypeMeiTui = 4
    case DBMZTypeQingXin = 5
    case DBMZTypeZaHui = 6
}

typealias DBMZColor = UIColor.LocalColorName

extension UIColor{
    enum LocalColorName:String {
        case barTintColor = "#1A1A1A"  /*navigationbar 的颜色*/
        case tabbarSelectedTextColor = "#68BB1E"
        case viewBackgroundColor = "#E7EBEE"
    }
    
    convenience init(colorNamed name:LocalColorName) {
        self.init(rgba:name.rawValue)
    }
}