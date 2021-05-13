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
    func loadData(isPullUp:Bool,finished:@escaping (Bool)->()) {
        guard let access_token = ZTUserAccountViewModel.shared.access_token else {
            return
        }
        var parametor = ["access_token":access_token]
        
        let maxid = self.viewModelArray.last?.status?.id ?? 0
        
        if isPullUp{
            
            if maxid > 0 {
                
                parametor["max_id"] = "\(maxid - 1)"
                
            }
            
        }
        
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
            //如果是上拉 模型数组追加
            if isPullUp{
                
                self.viewModelArray = self.viewModelArray + tempArr
                
            }else{
                
                self.viewModelArray = tempArr
            }
            
     //       print(self.viewModelArray)
            
            finished(true)
        }
    }
}
