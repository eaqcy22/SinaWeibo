//
//  ZTHomeViewModel.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/9.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
import SDWebImage
class ZTHomeViewModel: NSObject {
    
    lazy var viewModelArray:[ZTHomeCellModel] = [ZTHomeCellModel]()
    //MARK: 加载数据方法
    func loadData(isPullUp:Bool,finished:@escaping (Bool,Int)->()) {
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
                
                finished(false,0)
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
            
           self.cacheStatusSingleImage(array: tempArr, finished: finished)
        }
    }
    //缓存单张图片的方法
    private func cacheStatusSingleImage(array:[ZTHomeCellModel],finished:@escaping (Bool,Int)->()){
    
        let group = DispatchGroup()
        
        if array.count == 0{
            //这里也要回调finished
            finished(true, 0)
            return
        }
        //遍历视图模型
        for viewModel in array{
        
            if viewModel.imageInfo?.count == 1 {
                //只有一张图片
                //执行下载操作
                group.enter()
                let url = URL(string: viewModel.imageInfo?.first?.wap360 ?? "")
                
                SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    
                    print("单图下载成功")
                    group.leave()
                })
            }
        }
        //执行统一的回调
        group.notify(queue: DispatchQueue.main) {
            print("所有图片下载完毕")
            finished(true, array.count)
        }
        
    }
}
