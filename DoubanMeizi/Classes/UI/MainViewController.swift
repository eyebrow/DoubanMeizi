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
    //拉刷新控制器
    var refreshControl = UIRefreshControl()
    var infiniteScrollingView:UIView?
    
    var refreshing: Bool = false {
        didSet {
            if (self.refreshing) {
                self.refreshControl.beginRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "加载中...")
                print("Loading...")
            }
            else {
                
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: "完成加载")
                print("Loaded & set:Pull to Refresh")
            }
        }
    }
    
    var loadMoreEnable:Bool = true
    var loadingMore:Bool = false {
        
        willSet{
            if self.loadMoreEnable {
                self.loadMoreEnable = false
            }
            else{
                return
            }
        }
        
        didSet{
            if self.loadingMore {
                self.loadMore()
            }
            else{
                self.tableView.tableFooterView = nil
            }
        }
    }
    
    var currentPage:Int = 1
    
    override func loadView() {
        super.loadView()
        self.setup()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.type = DBMZType.DBMZTypeAll
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
        
        self.setupRefreshView()

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
            
            guard index < self.navDataSource.count else {return}
            let model:DBMZNavPageModel = self.navDataSource.get(index)
            
            self.requetMainPage(model.url, block: { (_dataArray :[DBMZMainPageModel]) in
                self.mainPageDataSource = _dataArray
                self.tableView?.reloadData()
            })
            
        }
        
        self.view .addSubview(self.cagegoryMenu!)
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 64 + 40, width: SCREEN_WIDTH, height: self.view.bounds.size.height - 64 - 40), style: .Plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view .addSubview(self.tableView)
    }
    
    func setupRefreshView() {
        //添加刷新
        
        self.refreshControl.addTarget(self, action:#selector(refreshData), forControlEvents: .ValueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
        self.tableView.addSubview(self.refreshControl)
        
        self.setupInfiniteScrollingView()
    }
    
    // 刷新数据
    func refreshData() {
        //移除老数据
        self.mainPageDataSource?.removeAll()
        self.currentPage = 0
        
        print(self.type.rawValue)
        guard self.type.rawValue < self.navDataSource?.count else {return}
        let model:DBMZNavPageModel = self.navDataSource.get(self.type.rawValue)
        
        self.refreshing = true
        self.requetMainPage(model.url, block: { (_dataArray :[DBMZMainPageModel]) in
            
            self.refreshing = false
            self.mainPageDataSource = _dataArray
            self.tableView?.reloadData()
        })
    }
    
    //上拉刷新
    private func setupInfiniteScrollingView() {
        self.infiniteScrollingView = UIView(frame: CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, 60))
        self.infiniteScrollingView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.infiniteScrollingView!.backgroundColor = UIColor.whiteColor()
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityViewIndicator.color = UIColor.darkGrayColor()
        activityViewIndicator.frame = CGRectMake(self.infiniteScrollingView!.frame.size.width/2-activityViewIndicator.frame.width/2, self.infiniteScrollingView!.frame.size.height/2-activityViewIndicator.frame.height/2, activityViewIndicator.frame.width, activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.infiniteScrollingView!.addSubview(activityViewIndicator)
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
            
            self.requetMainPage(allUrl, block: { (_dataArray :[DBMZMainPageModel]) in
                
                self.mainPageDataSource = _dataArray
                self.tableView?.reloadData()
            })
            
        }
    }
    
    func requetMainPage(url:String,block:([DBMZMainPageModel])-> Void){
        
        //self.refreshing = true
        DBMZDataRequestManager.fetchAllPageData(url: url) { (_dataArray :[DBMZMainPageModel]) in
            
            guard _dataArray.count != 0 else {return}
            
            if let datas:[DBMZMainPageModel] = [DBMZMainPageModel](_dataArray){
//                self.mainPageDataSource = datas
//                self.tableView?.reloadData()
                block(datas)
            }
            //self.refreshing = false
        }
    }

}

// MARK: - @protocol UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let model = self.mainPageDataSource.get(indexPath.row)
        guard model != nil else{return}
        let vc = DetailPageViewController()
        vc.url = model.jumpUrl
        vc.titleStr = model.title
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        guard model != nil else{return UITableViewCell()}
        //guard let type: MessageContentType = chatModel.messageContentType where chatModel != nil else {
        let cell = MainPageTableViewCell(style: .Default, reuseIdentifier: "MainPageCell")
        cell.updateCell(imageUrl: model.imageUrl, title: model.title)
        //}
        
        //当下拉到底部，执行loadMore()
        if (indexPath.row == self.mainPageDataSource.count - 1) {
            self.tableView.tableFooterView = self.infiniteScrollingView
            self.loadingMore = true
        }
        
        return cell//type.chatCell(tableView, indexPath: indexPath, model: chatModel, viewController: self)!
    }
    
    func loadMore(){
        print("loadMore")
        
        self.currentPage += 1
        
        print(self.type.rawValue)
        guard self.type.rawValue < self.navDataSource?.count else {return}
        let model:DBMZNavPageModel = self.navDataSource.get(self.type.rawValue)
        
        let url:String = model.url + "?pager_offset=\(self.currentPage)"
        
        print(url)
        
        self.requetMainPage(url, block: { (_dataArray :[DBMZMainPageModel]) in
            
            self.loadingMore = false
            guard _dataArray.count > 0 else {return}
            
            for item in _dataArray{
                self.mainPageDataSource.append(item)
            }
            
            self.tableView?.reloadData()
        })

    }
}

