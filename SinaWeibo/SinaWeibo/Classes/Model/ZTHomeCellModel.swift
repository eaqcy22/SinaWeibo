//
//  ZTHomeCellModel.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTHomeCellModel: NSObject {
//用户头像url
    var headURL:URL?
//用户等级图片
    var mbrankImage: UIImage?
//认证类型图片
    var verifiedImage: UIImage?
    
    var status:ZTStatus?{
    
        didSet{
        
            headURL = URL(string: status?.user?.avatar_large ?? "")
            //为图片对象赋值
            dealmbrankImage()
            
            dealverifiedImage()
        }
    }
    ///判断并返回转发微博或原创微博的视图模型
    var imageInfo:[ZTPicInfo]?{
    
        if status?.retweeted_status != nil {
        
            //转发微博
            return status?.retweeted_status?.pic_urls
        }
        //原创微博
        return status?.pic_urls
    }
    private func dealmbrankImage(){
        //会员等级 0 - 6
        let mbrank = status?.user?.mbrank ?? 0
        
        if mbrank >= 0 && mbrank <= 6 {
            
            mbrankImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }else{
        
            mbrankImage = UIImage(named: "common_icon_membership_expired")
        }
    }
    private func dealverifiedImage(){
        //认证类型:-1 - 没有认证 0 - 认证用户 2,3,5 - 企业认证 220 - 达人 草根
        let verifiedType = status?.user?.verified_type ?? -1
        
        switch verifiedType {
        case 0:
            verifiedImage = UIImage(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verifiedImage = UIImage(named: "avatar_grassroot")
        default:
            return
        }
        
    }
}
