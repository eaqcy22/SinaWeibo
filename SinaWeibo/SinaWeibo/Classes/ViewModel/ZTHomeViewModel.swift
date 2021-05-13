//
//  ZTHomeViewModel.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/9.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTHomeViewModel: NSObject {

   lazy var viewModelArray:[ZTHomeCellModel] = [ZTHomeCellModel]()
    //MARK: 加载数据方法
    func loadData(finished:@escaping (Bool)->()) {
        guard let access_token = ZTUserAccountViewModel.shared.access_token else {
            return
        }
        let parametor = ["access_token":access_token]
        
        ZTNetworkTool.shared.request(urlString: "https://api.weibo.com/2/statuses/home_timeline.json", method: .GET, parametor: parametor) { (res, error) in
            if error != nil{
                
                finished(false)
                return
            }
            let dict = res as! [String : Any]
            
            let array = dict["statuses"] as! [[String : Any]]
            
            //字典转模型
            var tempArr = [ZTHomeCellModel]()
            
            for item in array{
                
                let model = ZTStatus()
                
                let cellModel = ZTHomeCellModel()
                
                model.yy_modelSet(with: item)
                
                cellModel.status = model
                
                tempArr.append(cellModel)
            }
            //给模型属性赋值
            self.viewModelArray = tempArr
            
            print(self.viewModelArray)
            
            finished(true)
        }
    }
}
