//
//  ZTNetworkTool.swift
//  Swift网络框架封装及混编
//
//  Created by sharayuki on 2017/1/6.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
import AFNetworking
enum HTTPMethod: Int{
    
    case GET
    
    case POST
}
class ZTNetworkTool: AFHTTPSessionManager {
//MARK: 单例创建
    static let shared:ZTNetworkTool = {
    
        let tools = ZTNetworkTool(baseURL: nil)
        
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    
    }()
    //MARK: 网络请求的方法
    func request(urlString: String,method: HTTPMethod,parametor: Any?,finished: @escaping (Any?,Error?) -> ()) {
        
        let succesCallBack = {(task:URLSessionDataTask, resp:Any?) in
        
            finished(resp,nil)
        }
        
        let failCallBack = {(task: URLSessionDataTask?, error: Error) -> () in
            
            finished(nil,error)
        }
        if method == .GET{
        
            self.get(urlString, parameters: parametor, progress: nil, success: succesCallBack, failure: failCallBack)
        
        }else{
        
            self.post(urlString, parameters: parametor, progress: nil, success: succesCallBack, failure: failCallBack)
        
        }
        
    }
}
