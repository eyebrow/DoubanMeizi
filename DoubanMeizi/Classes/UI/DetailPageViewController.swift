//
//  DetailPageViewController.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/29.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import Kingfisher
import SKPhotoBrowser

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
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView =  UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.collectionView!.backgroundColor = UIColor.grayColor()
        self.collectionView!.dataSource  = self
        self.collectionView!.delegate = self
        
        layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)
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
        print("row:\(indexPath.row)")
        print("item:\(indexPath.item)")
        print("section:\(indexPath.section)")

        cell.imageStr = self.imageArray?[indexPath.section]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var images = [SKPhoto]()
        
        for imageUrl in self.imageArray! {
            let photo = SKPhoto.photoWithImageURL(imageUrl)
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
        }
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.section)
        presentViewController(browser, animated: true, completion: {})
        
        //网络图片
//        var remoteImage = [NSURL]()
//        for imageUrl in self.imageArray! {
//            let photo = NSURL(string:imageUrl)
//            
//            remoteImage.append(photo!)
//        }
//
//        //网路数据源
//        let browser = PhotoBrowserView.initWithPhotos(withUrlArray: remoteImage)
//        //类型为网络
//        browser.sourceType = SourceType.REMOTE
//        //设置展示的第一张图片
//        browser.index = indexPath.row
//        //显示
//        browser.show()
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
        self.imageView?.contentMode = .Center
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
