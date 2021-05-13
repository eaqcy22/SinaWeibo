//
//  ZTHomeTableViewController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/4.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
import YYModel
private let statusCellid = "StatusCell"
private let retweentCellid = "RetweentCell"
class ZTHomeTableViewController: ZTBaseTableViewController {
//视图模型
    let homeViewModel:ZTHomeViewModel = ZTHomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !userLogin{
            
            visitorView.changeLoginView(imageName: "visitordiscover_feed_image_smallicon", title: "关注一些人到这里看看有什么惊喜", isHome: true)
            
            return
        }
        
        setUpUI()
        
        loadData()
    }
//MARK: UI设置
    func setUpUI() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", imgName: "navigationbar_pop", target: self, action: #selector(clickOther))
        let cellNib = UINib(nibName: "ZTStatusCell", bundle: nil)
        
        let retweentNib = UINib(nibName: "ZTRetweetedStatusCell", bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: statusCellid)
        
        tableView.register(retweentNib, forCellReuseIdentifier: retweentCellid)
        
        self.tableView.rowHeight = 1000
        
    }
//MARK: 加载数据
    func loadData() {
        //加载数据
        homeViewModel.loadData { (isSuccess) in
            if !isSuccess{
                
                print("加载错误")
            }
            
            self.tableView.reloadData()
        }

    }
//MARK: barbuttonitem
    func clickOther() {
        
        let otherVC = ZTOtherTableViewController()
        
        navigationController?.pushViewController(otherVC, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
//MARK: 分类方法 tableView数据源
    extension ZTHomeTableViewController{
    
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return self.homeViewModel.viewModelArray.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
            
            let cellModel = self.homeViewModel.viewModelArray[indexPath.row]
            
            let cellid = getCellid(viewModel: cellModel)
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ZTStatusCell
            
            print(cellModel.yy_modelDescription())
            
            cell.viewModel = cellModel
            
            return cell
        }
//判断cell的类型方法
        private func getCellid(viewModel:ZTHomeCellModel)->String{
        
            if viewModel.status?.retweented_status != nil {
                
                return retweentCellid
            }else{
            
                return statusCellid
            }
            
        
        }
    
}


