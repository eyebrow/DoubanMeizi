//
//  globlal.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/28.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height

struct MainPageModel {
    let title:String!
    let url:String!
    
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