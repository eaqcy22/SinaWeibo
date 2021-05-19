//
//  ZTPicViewCell.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTPicViewCell: UICollectionViewCell {
    //cell的数据模型
    var picInfo:ZTPicInfo?{
    
        didSet{
        
            let url = URL(string: picInfo?.wap360 ?? "")
            
            iconV.sd_setImage(with: url)
            
            let urlString = url?.absoluteString
            
            gifV.isHidden = urlString!.hasSuffix(".gif")
            
        }
    }
    //添加图片
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        
        self.contentView.addSubview(iconV)
        
        contentView.addSubview(gifV)
        
        iconV.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.contentView)
            
        }
        gifV.snp.makeConstraints { (make) in
            
            make.bottom.right.equalTo(self.contentView)
        }
        
        
    }
//懒加载图片视图
    lazy var iconV:UIImageView = {
    
        let i = UIImageView()
        
        i.contentMode = .scaleAspectFill
        
        i.clipsToBounds = true
        
        return i
    }()
//懒加载gif小图标
    lazy var gifV:UIImageView = {
    
        let g = UIImageView(image: #imageLiteral(resourceName: "timeline_image_gif"))
        
        return g
    }()
}
