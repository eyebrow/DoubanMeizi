//
//  ViewController.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/22.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    override func loadView() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        
        self.title = "豆瓣妹子"
        
        Alamofire.request(.GET, "http://www.dbmeinv.com").responseJSON() {
            
            response in
            guard let JSON = response.result.value else { return }
            print("JSON: \(JSON)")
            
        }
    }

}
