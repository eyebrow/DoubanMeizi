//
//  DBMZDataRequestManager.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/26.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import Foundation
import Alamofire
import hpple

let BASEURL = "http://www.dbmeinv.com"
let MainPageXpathQueryString = "//div[@class=\"panel-heading clearfix\"]/ul[@class=\"nav nav-pills\"]"


typealias dataBlock = ([MainPageModel])->Void

class DBMZDataRequestManager: NSObject {
    
    class func fetctMainPageData(block:dataBlock) {
        
        Alamofire.request(.GET, BASEURL)
            .responseString { response in
                
                guard response.result.value != nil else { return }
                //print("JSON: \(JSON)")
                
                let hpple:TFHpple = TFHpple(data: response.data, isXML: false)
                
                let items:NSArray = hpple.searchWithXPathQuery(MainPageXpathQueryString)
                
                guard  items.count > 0  else {return}
                
                for item in items {
                    
                    let lis:NSArray = item.childrenWithTagName("li")
                    
                    var dataList = [MainPageModel]()
                    
                    for chlidItem in lis {
                        
                        let chileItemData:NSData = (chlidItem as! TFHppleElement).raw.dataUsingEncoding(NSUTF8StringEncoding)!
                        let aHpple:TFHpple = TFHpple(HTMLData: chileItemData)
                        
                        let aNodes:NSArray = aHpple.searchWithXPathQuery("//a")
                        
                        let aNode:TFHppleElement = aNodes.firstObject as! TFHppleElement
                        
                        print(aNode.objectForKey("href"))
                        print(aNode.text())
                        
                        //guard aNode.text() != nil && aNode.objectForKey("hred") != nil else {continue}
                        
                        let model = MainPageModel(title: aNode.text(), url: aNode.objectForKey("hred"))
//                        model.title = aNode.text()
//                        model.title = aNode.objectForKey("hred")

                        dataList.append(model)
                    }
                    
                    guard dataList.count > 0 else {return}
                    
                    block(dataList)
                }
    
                
        }
    }
    
}