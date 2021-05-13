//
//  ZTStatus.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/9.
//  Copyright © 2017年 sharayuki. All rights reserved.
// 该模型是处理微博首页数据的模型

import UIKit
import YYModel
class ZTStatus: NSObject {
    
    var id: Int64 = 0
    
    ///微博正文
    var text: String?
    
    ///微博来源
    var source: String?
    
    ///微博时间
    var created_at: String?
    
    ///微博作者信息
    var user: ZTUser?
    
    //配图视图的数组
    var pic_urls: [ZTPicInfo]?
    
    ///转发微博
    var retweented_status: ZTStatus?
    //YYModel的返回自定义容器元素处理方法
    static func modelContainerPropertyGenericClass()->[String : Any]?{
    
        return ["pic_urls" : ZTPicInfo.self]
    
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
