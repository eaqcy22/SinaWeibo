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
//微博发布来源
    var sourceText: String?
//微博发布时间
    var timeText : String?{
    
        //1 实例化日期格式化对象
        let dateFormatter = DateFormatter()
        //2.指定日期格式化
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        //在真机必须设置本地化信息否则转换失败
        dateFormatter.locale = Locale(identifier: "en")
        //3 字符串转换日期对象
        guard let sinaDate = dateFormatter.date(from: status?.created_at ?? "") else {
            
            return "穿越时空的少女/少年"
        }
        //4 处理日期
        let calender = Calendar.current
        let currentDate = Date()
        let result = calender.dateComponents([.day,.year], from: sinaDate, to: currentDate)
        if result.year == 0{
            //今年
            if calender.isDateInToday(currentDate) {
                //今天
                let delta = currentDate.timeIntervalSince(sinaDate)
                if delta < 60 {
                    //当前分钟数
                    return "刚刚"
                }else if delta < 3600{
                    
                    //一小时内
                    return "\(Int(delta/60))分钟前"
                }else if delta > 3600{
                    //一天一小时外
                    return "\(Int(delta/3600))小时前"
                }
            }else if calender.isDateInYesterday(sinaDate){
                //昨天
                dateFormatter.dateFormat = "昨天 HH:mm"
                
                return dateFormatter.string(from: sinaDate)
            }else {
                
                //今年其他
                dateFormatter.dateFormat = "MM-dd HH:mm"
                return dateFormatter.string(from: sinaDate)
            }
        }else{
            //非当年
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            return dateFormatter.string(from: sinaDate)
        }
        return "qnmb"
    
    }
    var status:ZTStatus?{
    
        didSet{
        
            headURL = URL(string: status?.user?.avatar_large ?? "")
            //为图片对象赋值
            dealmbrankImage()
            
            dealverifiedImage()
            
            self.sourceText = dealSourceText(sourceStr: status?.source ?? "")
            
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
    //处理微博来源的方法
    private func dealSourceText(sourceStr:String)->String{
    
        let startFlag = "\">"
        let endFlag = "</a>"
        //判断是否能读取来源字符串
        guard let startRange = sourceStr.range(of: startFlag),let endRange = sourceStr.range(of: endFlag)else{
            
                return "来自星辰大海"
        }
        //upperBound 最大边界 lowerBound: 最小边界
        let range = startRange.upperBound ..< endRange.lowerBound
        //截取来源
        let subStr = sourceStr.substring(with: range)
        
        return subStr
    }
    

}
