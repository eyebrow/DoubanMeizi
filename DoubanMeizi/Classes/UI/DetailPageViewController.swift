//
//  DetailPageViewController.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/29.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import Kingfisher

class DetailPageViewController: UIViewController {

    var titleStr: String!
    var collectionView:UICollectionView?
    
    var imageArray: [String]?
    var url : String!
    
//    var url : String!{
//        didSet{
//            if url != nil {
//                DBMZDataRequestManager.fetchDetailPageData(url: url, block: { (_dataArray) in
//                    guard _dataArray.count > 0 else{return}
//                    self.imageArray = _dataArray
//                    self.collectionView?.reloadData()
//                })
//            }
//        }
//    }
    
    override func loadView() {
        super.loadView()
        
        self.title = titleStr
        
        self.collectionView =  UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView!.backgroundColor = UIColor.grayColor()
        self.collectionView!.dataSource  = self
        self.collectionView!.delegate = self
        self.collectionView!.registerClass(ImageTextCell.self, forCellWithReuseIdentifier: "ImageTextCell")
        
        self.view.addSubview(self.collectionView!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.requetMainPage(self.url) { (_dataArray:[String]) in
            
            guard _dataArray.count > 0 else{return}
            self.imageArray = _dataArray
            self.collectionView?.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requetMainPage(url:String,block:([String])-> Void){
        
        DBMZDataRequestManager.fetchDetailPageData(url: url) { (_dataArray :[String]) in
            
            guard _dataArray.count != 0 else {return}
            
            if let datas:[String] = [String](_dataArray){
                block(datas)
            }
            
        }
    }

}

extension DetailPageViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard self.imageArray != nil else{return 0}
        return self.imageArray!.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard self.imageArray?.count > 0 else{return UICollectionViewCell()}
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageTextCell", forIndexPath: indexPath) as! ImageTextCell
        
        cell.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH)
        cell.imageStr = self.imageArray?[indexPath.item]
        return cell
    }
}

//这里是自定义cell的代码
class ImageTextCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    var imageStr: NSString? {
        
        didSet {
            
            guard let URLString = imageStr, URL = NSURL(string: URLString as String) else {
                print("URL wrong")
                return
            }
            
            self.imageView!.kf_setImageWithURL(URL)
            
            self.sizeToFit()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView = UIImageView()
        self.addSubview(self.imageView!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
