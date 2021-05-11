//
//  ZTUserAount.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/8.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
///[__NSCFNumber length]: unrecognized selector sent to instance  在KVC的时候将一个NSNumber的对象当做了NSString使用
//遵守NSCoding协议 并且实现两个协议方法
class ZTUserAount: NSObject,NSCoding {
    //设置模型的属性
    ///用户授权的唯一票据，用于调用微博的开放接口，同时也是第三方应用验证微博用户登录的唯一票据，第三方应用应该用该票据和自己应用内的用户建立唯一影射关系，来识别登录状态，不能使用本返回值里的UID字段来做登录识别。
    var access_token: String?
    
    ///access_token的生命周期，单位是秒数。 表示token 过多少秒之后会过期
    ///2022-01-06 08:40:02 +0000
    //开发者账户的有效期是 5年
    //普通用户的token使用有效期是 7天
    //测试用户的token有效期是 1 天
    var expires_in: Double = 0 {
        didSet {
            //根据当前日期 + expires_in 计算token过期日期
            expires_date = Date(timeIntervalSinceNow: expires_in)
            print(expires_date)
        }
    }
    
    var expires_date: Date?
    ///授权用户的UID，本字段只是为了方便开发者，减少一次user/show接口调用而返回的，第三方应用不能用此字段作为用户登录状态的识别，只有access_token才是用户授权的唯一票据。
    var uid: String?
    ///用户昵称
    var screen_name: String?
    ///用户头像地址（大图），180×180像素
    var avatar_large: String?
    //重写初始化方法
    init(dict:[String: Any]) {
        
        super.init()
        
        setValuesForKeys(dict)
        
    }
    //避免赋值崩溃的方法
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    //MARK: 归档解档
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as! String?
        self.expires_date = aDecoder.decodeObject(forKey: "expires_date") as! Date?        
        self.uid = aDecoder.decodeObject(forKey: "uid") as! String?
        self.screen_name = aDecoder.decodeObject(forKey: "screen_name") as! String?
        self.avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as! String?

    }
}
