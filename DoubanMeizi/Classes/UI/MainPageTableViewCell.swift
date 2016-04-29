//
//  MainPageTableViewCell.swift
//  DoubanMeizi
//
//  Created by iprincewang on 16/4/29.
//  Copyright © 2016年 com.tencent.prince. All rights reserved.
//

import UIKit
import Kingfisher

class MainPageTableViewCell: UITableViewCell {

    var thumailImgView:UIImageView!
    var titleLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self .setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func setup() {
        self.thumailImgView = UIImageView(frame: CGRect(origin: CGPoint(x:10 ,y:10), size: CGSize(width: 60, height: 60)))
        self.thumailImgView.contentMode = .ScaleToFill
        self.contentView .addSubview(self.thumailImgView)
        self.titleLabel = UILabel(frame: CGRect(x: 80, y: 25, width: SCREEN_WIDTH - 70, height: 20))
        self.titleLabel.contentMode = .Left
        self.contentView.addSubview(self.titleLabel)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(imageUrl im:String?,title ti:String){
        //self.thumailImgView.image = im
        
        guard let URLString = im, URL = NSURL(string: URLString) else {
            print("URL wrong")
            return
        }
        
        self.thumailImgView.kf_setImageWithURL(URL)
        self.titleLabel.text = ti
    }

}
