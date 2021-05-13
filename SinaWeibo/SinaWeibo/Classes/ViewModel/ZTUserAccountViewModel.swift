

//
//  ZTUserAccountViewModel.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/9.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  用户账户视图模型

import UIKit
//用户缓存路径
private let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")

class ZTUserAccountViewModel: NSObject {
//用户账户信息模型
    var userAccount:ZTUserAount?
//用户access_token
    var access_token: String?{
    
        return self.userAccount?.access_token
    }
//单例设计
    static let shared:ZTUserAccountViewModel = ZTUserAccountViewModel()
    
    override init() {
        
        super.init()
        
        self.userAccount = self.loadUserAccount()
        
    }
//登录判断
    var userLogin : Bool{
    
        if userAccount?.access_token != nil && isExpires == false {
            
            return true
        }
    
        return false
    }
//用户头像URL
    var url : URL?{
    
        return URL(string: userAccount?.avatar_large ?? "")
    }
//token过期判断
    var isExpires : Bool{
    
        if userAccount?.expires_date?.compare(Date()) == .orderedDescending {
            
            return false
        }
        
        return true
    }
//MARK: 获取用户数据以及token
    
    //MARK: 取得令牌
    func loadAccessToken(code:String,finished:@escaping (Bool)->()){
        
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let dict = ["client_id" : client_id,
                    "client_secret" : client_secret,
                    "code" : code,
                    "grant_type" : "authorization_code",
                    "redirect_uri" : redirect_uri]
        ZTNetworkTool.shared.request(urlString: urlString, method: .POST, parametor: dict) { (response, error) in
            
            if error != nil{
                //展示访问出错的信息
                SVProgressHUD.showError(withStatus: "世界上最遥远的距离就是我在网的这端,你在网的那端")
                
                finished(false)
                
                return
                
            }else{
                //取得令牌
                let dict:[String : Any] = response as! [String : Any]
                //请求用户信息
                self.getUserInfo(dict: dict,finished: finished)
            }
        }
    }
    //MARK: 请求用户信息
    private func getUserInfo(dict:[String : Any],finished:@escaping (Bool)->()){
        //取出对应的参数
        let access_token = dict["access_token"]
        
        let uid = dict["uid"]
        //拼接参数字典
        let parametor = ["access_token":access_token,
                         "uid":uid]
        
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        ZTNetworkTool.shared.request(urlString: urlString, method: .GET, parametor: parametor) { (response, error) in
            
            if error != nil{
                
                print("请求用户信息出错")
                
                return
                
            }else{
                //返回的数据是字典
                var userInfo:[String : Any] = response as! [String : Any]
                //合并字典元素成为我们需要的用户信息
                for (key,value) in dict{
                    
                    userInfo[key] = value
                    
                }
                //转换为模型数据
                let userAount = ZTUserAount(dict: userInfo)
                //登录账号
                self.userAccount = userAount
                //存储到本地
                self.saveUserInfo(userAount: userAount)
                //登录成功
                finished(true)
            }
        }
    }
    //存储用户账户数据
    private func saveUserInfo(userAount:ZTUserAount){
        //拼接文件路径
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("account.plist")
        print(path)
        //归档到本地沙盒
        NSKeyedArchiver.archiveRootObject(userAount, toFile: path)
        
    }
    //从沙盒读取用户账户数据
    func loadUserAccount() -> ZTUserAount? {
        
        if let cacheAccount = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? ZTUserAount{
            
            return cacheAccount        
        }
        //默认无法获取用户数据
        return nil
    }
}
