//
//  ZTUser.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  该模型为用户作者信息模型

import UIKit

class ZTUser: NSObject {
//作者名称
    var screen_name: String?
//作者头像
    var avatar_large: String?
//认证类型:-1 - 没有认证 0 - 认证用户 2,3,5 - 企业认证 220 - 达人 草根
    var verified_type: Int = 0
//会员等级 0 - 6
    var mbrank: Int = 0
}
