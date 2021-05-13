//
//  ZTPicInfo.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  处理微博的图片数组模型数据

import UIKit

class ZTPicInfo: NSObject {

    var thumbnail_pic : String?{
    
        didSet{
          wap360 = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
          bimiddle = thumbnail_pic?.replacingOccurrences(of: "/thumbnail/", with: "/bimiddle/")

        }
    }
    var wap360:String?
    
    var bimiddle:String?
}
