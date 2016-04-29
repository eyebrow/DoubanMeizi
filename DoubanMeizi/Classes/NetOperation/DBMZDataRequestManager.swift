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
let AllPageXpathQuertString = "//div[@class=\"panel-body\"]/ul[@class=\"thumbnails\"]"
let DetailPageXpathQuertString = "//div[@class=\"panel-body markdown\"]"

typealias navDataBlock = ([DBMZNavPageModel])->Void
typealias MainDataBlock = ([DBMZMainPageModel])->Void
typealias DetailDataBlock = ([String])->Void

class DBMZDataRequestManager: NSObject {
    
    class func fetctMainPageData(block:navDataBlock) {
        
        Alamofire.request(.GET, BASEURL)
            .responseString { response in
                
                guard response.result.value != nil else { return }
                //print("JSON: \(JSON)")
                
                let hpple:TFHpple = TFHpple(data: response.data, isXML: false)
                
                let items:NSArray = hpple.searchWithXPathQuery(MainPageXpathQueryString)
                
                guard  items.count > 0  else {return}
                
                var dataList = [DBMZNavPageModel]()
                
                for item in items {
                    
                    let lis:NSArray = item.childrenWithTagName("li")

                    for chlidItem in lis {
                        
                        let chileItemData:NSData = (chlidItem as! TFHppleElement).raw.dataUsingEncoding(NSUTF8StringEncoding)!
                        let aHpple:TFHpple = TFHpple(HTMLData: chileItemData)
                        
                        let aNodes:NSArray = aHpple.searchWithXPathQuery("//a")
                        
                        let aNode:TFHppleElement = aNodes.firstObject as! TFHppleElement
                        
                        print(aNode.objectForKey("href"))
                        print(aNode.text())
                        
                        //guard aNode.text() != nil && aNode.objectForKey("hred") != nil else {continue}
                        
                        let model = DBMZNavPageModel(title: aNode.text(), url: aNode.objectForKey("href"))
//                        model.title = aNode.text()
//                        model.title = aNode.objectForKey("hred")

                        dataList.append(model)
                    }
                    
                    
                }
                
                guard dataList.count > 0 else {return}
                
                block(dataList)
    
                
        }
    }
    
    class func fetchAllPageData(url hurl:String,block:MainDataBlock) {
        Alamofire.request(.GET, hurl)
        .responseString { response in
            guard response.result.value != nil else { return }
            let hpple:TFHpple = TFHpple(data: response.data, isXML: false)
            let items:NSArray = hpple.searchWithXPathQuery(AllPageXpathQuertString)
            
            guard  items.count > 0  else {return}
            
            var dataList = [DBMZMainPageModel]()
            
            for item in items {
                let lis:NSArray = item.childrenWithTagName("li")
                
                
                for chlidItem in lis{
                    let chileItemData:NSData = (chlidItem as! TFHppleElement).raw.dataUsingEncoding(NSUTF8StringEncoding)!
                    let aHpple:TFHpple = TFHpple(HTMLData: chileItemData)
                    
                    let aNodes:NSArray = aHpple.searchWithXPathQuery("//div[@class=\"img_single\"]/a")
                    
                    let aNode:TFHppleElement = aNodes.firstObject as! TFHppleElement
                    
                    let jumpUrl:String = aNode.objectForKey("href")
                    
                    let imgNodes:NSArray = aHpple.searchWithXPathQuery("//div[@class=\"img_single\"]/a/img")
                    let imgNode:TFHppleElement = imgNodes.firstObject as! TFHppleElement
                    let title:String = imgNode.objectForKey("title")
                    let thumailImgUrl = imgNode.objectForKey("src")
                    
                    print("==================")
                    print(title)
                    print(thumailImgUrl)
                    print(jumpUrl)
                    
                    let model = DBMZMainPageModel(title: title, imageUrl: thumailImgUrl, jumpUrl: jumpUrl)
                    
                    dataList.append(model)

                }
                
            }
            
            guard dataList.count > 0 else {return}
            
            block(dataList)
        }
    }
    
    class func fetchDetailPageData(url hurl:String,block:DetailDataBlock) {
        Alamofire.request(.GET, hurl)
            .responseString { response in
                guard response.result.value != nil else { return }
                let hpple:TFHpple = TFHpple(data: response.data, isXML: false)
                let items:NSArray = hpple.searchWithXPathQuery(DetailPageXpathQuertString)
                
                guard  items.count > 0  else {return}
                
                var dataList = [String]()
                
                for chlidItem in items {
                    
                    let chileItemData:NSData = (chlidItem as! TFHppleElement).raw.dataUsingEncoding(NSUTF8StringEncoding)!
                    let aHpple:TFHpple = TFHpple(HTMLData: chileItemData)
                    
//                    let aNodes:NSArray = aHpple.searchWithXPathQuery("//div[@class=\"img_single\"]/a")
//                    
//                    let aNode:TFHppleElement = aNodes.firstObject as! TFHppleElement
//                    
//                    let jumpUrl:String = aNode.objectForKey("href")
                    
                    let imgNodes:NSArray = aHpple.searchWithXPathQuery("//div[@class=\"topic-figure cc\"]/img")
                    
                    for imageNode in imgNodes{
                        
                        let imgNode:TFHppleElement = imageNode as! TFHppleElement
                        //let title:String = imgNode.objectForKey("title")
                        let thumailImgUrl = imgNode.objectForKey("src")
                        
                        print("==================")
                        print(thumailImgUrl)
                        
                        
                        dataList.append(thumailImgUrl)
                    }
                    
                    
                }
                
                guard dataList.count > 0 else {return}
                
                block(dataList)
        }
    }
    
    
}