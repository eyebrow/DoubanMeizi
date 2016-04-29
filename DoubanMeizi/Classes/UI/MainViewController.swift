//
//  ViewController.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/22.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import Alamofire
import hpple
import SnapKit
import Cent

class MainViewController: UIViewController {
    
    var navDataSource:[DBMZNavPageModel]!
    var cagegoryMenu:DBMZCategoryMenuView!
    var tableView:UITableView!
    var type:DBMZType = DBMZType.DBMZTypeAll
    
    var mainPageDataSource:[DBMZMainPageModel]!
    
    
    override func loadView() {
        super.loadView()
        self.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self .requetNavPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        
        self.title = "豆瓣妹子"
        self.view.backgroundColor = UIColor(colorNamed: DBMZColor.viewBackgroundColor)
        self .setupCagegoryMenuView()
        
        self.setupTableView()

    }
    func setupCagegoryMenuView() {
        self.cagegoryMenu = DBMZCategoryMenuView()
        
        self.cagegoryMenu?.frame = CGRect(x: 0,y: 64,width: SCREEN_WIDTH,height: 40)
        
        self.cagegoryMenu?.indexChangeBlock = { (index:Int) -> Void in
            
            switch index {
            case 0:
                self.type = DBMZType.DBMZTypeAll
            case 1:
                self.type = DBMZType.DBMZTypeDaXiong
            case 2:
                self.type = DBMZType.DBMZTypeQiaoTun
            case 3:
                self.type = DBMZType.DBMZTypeHeisi
            case 4:
                self.type = DBMZType.DBMZTypeMeiTui
            case 5:
                self.type = DBMZType.DBMZTypeQingXin
            case 6:
                self.type = DBMZType.DBMZTypeZaHui
            default:
                self.type = DBMZType.DBMZTypeAll
            }
            
            print(self.type)
        }
        
        self.view .addSubview(self.cagegoryMenu!)
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: self.cagegoryMenu.bounds.origin.y + self.cagegoryMenu.bounds.size.height, width: SCREEN_WIDTH, height: self.view.bounds.size.height - self.cagegoryMenu.bounds.size.height), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view .addSubview(self.tableView)
    }
    
    func requetNavPage() {
        
        DBMZDataRequestManager.fetctMainPageData { (_dataArray:[DBMZNavPageModel]) in
            
            guard _dataArray.count != 0 else {return}
            
            self.navDataSource = _dataArray
            
            print(self.navDataSource)
            
            var titles = [String]()
            
            for item in self.navDataSource {
                
                print(item.title)
                
                titles.append(item.title)
            }
            
            self.cagegoryMenu.titles = titles as [String]
            self.cagegoryMenu .awakeFromNib()
            
            let allUrl = self.navDataSource.get(0).url
            
            guard allUrl != nil else{return}
            
            self.requetMainPage(allUrl)
        }
    }
    
    func requetMainPage(url:String) {
        
        
        DBMZDataRequestManager.fetchAllPageData(url: url) { (_dataArray :[DBMZMainPageModel]) in
            
            guard _dataArray.count != 0 else {return}
            
            if let datas:[DBMZMainPageModel] = [DBMZMainPageModel](_dataArray){
                self.mainPageDataSource = datas
                self.tableView?.reloadData()
            }
            
        }
    }

}

// MARK: - @protocol UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}


// MARK: - @protocol UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.mainPageDataSource != nil else {return 0}
        return self.mainPageDataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let model = self.mainPageDataSource.get(indexPath.row)
        //guard let type: MessageContentType = chatModel.messageContentType where chatModel != nil else { return 0 }
        return 80//type.chatCellHeight(chatModel)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let model = self.mainPageDataSource.get(indexPath.row)
        //guard let type: MessageContentType = chatModel.messageContentType where chatModel != nil else {
        let cell = MainPageTableViewCell(style: .Default, reuseIdentifier: "MainPageCell")
        cell.updateCell(imageUrl: model.imageUrl, title: model.title)
        //}
        return cell//type.chatCell(tableView, indexPath: indexPath, model: chatModel, viewController: self)!
    }
}

