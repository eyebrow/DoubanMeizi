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

class MainViewController: UIViewController {
    
    var dataSource:[MainPageModel]!
    var cagegoryMenu:DBMZCategoryMenuView!
    var type:DBMZType = DBMZType.DBMZTypeAll
    
    override func loadView() {
        super.loadView()
        self.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self .requetMainPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        
        self.title = "豆瓣妹子"
        self.view.backgroundColor = UIColor(colorNamed: DBMZColor.viewBackgroundColor)
        self .setupCagegoryMenuView()

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
    
    func requetMainPage() {
        
        DBMZDataRequestManager.fetctMainPageData { (_dataArray:[MainPageModel]) in
            
            guard _dataArray.count != 0 else {return}
            
            self.dataSource = _dataArray
            
            print(self.dataSource)
            
            var titles = [String]()
            
            for item in self.dataSource {
                
                print(item.title)
                
                titles.append(item.title)
            }
            
            self.cagegoryMenu.titles = titles as [String]
            self.cagegoryMenu .awakeFromNib()
            
        }
    }

}

