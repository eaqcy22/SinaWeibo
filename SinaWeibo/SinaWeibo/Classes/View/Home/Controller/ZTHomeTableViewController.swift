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
//懒加载小菊花控件
    lazy var indicatorView:UIActivityIndicatorView? = {
    
        let inV = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        return inV
    }()
    //懒加载自定义刷新控件
    var refreshC:ZTRefreashControl?
    
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
        //实例化refreshControl
        refreshC = ZTRefreashControl()
        
        refreshC!.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        tableView.register(cellNib, forCellReuseIdentifier: statusCellid)
        
        tableView.register(retweentNib, forCellReuseIdentifier: retweentCellid)
        //取消分隔线
        tableView.separatorStyle = .none
        //设置表尾视图为加载视图
        tableView.tableFooterView = indicatorView
       // self.tableView.rowHeight = 700
     //   tableView.tableHeaderView = refreshC
       // tableView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0)
        
        view.addSubview(refreshC!)
        
        
    }
//MARK: 加载数据
    func loadData() {
        //加载数据
        homeViewModel.loadData(isPullUp: (indicatorView?.isAnimating)!) { (isSuccess,count) in
            if !isSuccess{
                
                print("加载错误")
            }
            //判断是否提示
            if !self.indicatorView!.isAnimating{
                
                self.startTipAnimating(count: count)
                
            }
            //加载数据完毕停止动画
            self.refreshC?.endRreashing()
            //停止转动小菊花
            self.indicatorView?.stopAnimating()
            
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
            
        //    print(cellModel.yy_modelDescription(),cellid)
            
            cell.viewModel = cellModel
            
            return cell
        }
//返回行高的方法
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            let cellModel = self.homeViewModel.viewModelArray[indexPath.row]
            
            let cellid = getCellid(viewModel: cellModel)
            
            let cell = getCellById(cellid: cellid)
            
            cell.viewModel = cellModel
           //强制刷新子控件的frame
            cell.layoutIfNeeded()
            
            return cell.buttomView.frame.maxY
            
        }
//根据cellid来返回不同类型的cell方法
        private func getCellById(cellid:String) -> ZTStatusCell{
            
            if cellid == statusCellid{
            
                let cell = UINib(nibName: "ZTStatusCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! ZTStatusCell
                
                return cell
            }else{
                let cell = UINib(nibName: "ZTRetweetedStatusCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as! ZTStatusCell
                
                return cell
            }
            
        }
//判断cell的类型方法
        private func getCellid(viewModel:ZTHomeCellModel)->String{
        
            if viewModel.status?.retweeted_status != nil {
                
                return retweentCellid
            }else{
            
                return statusCellid
            }
            
        
        }
//MARK: 判断是否需要静默加载
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            
            if indexPath.row == self.homeViewModel.viewModelArray.count - 2 && indicatorView?.isAnimating == false{
             //开始静默加载
                indicatorView?.startAnimating()
                
                loadData()
            }
        }
        //MARK: 加载提示Label的动画
        func startTipAnimating(count:Int){
            
            let tipLabel : UILabel = UILabel(text: "加载了\(count)条微博", font: 14, alignment: .center, preferWidth: 150, lines: 0, color: .gray)
            
            view.addSubview(tipLabel)
            
            let tipH : CGFloat = 25
            
            tipLabel.frame = CGRect(x: (screen_width / 2.0)-75, y: -tipH - 100, width: 150, height: tipH)
            
            tipLabel.backgroundColor = UIColor.orange
            
            UIView.animate(withDuration: 1, animations: {
                
                tipLabel.frame.origin.y = 0
                
            }) { (true) in
                UIView.animate(withDuration: 1, animations: {
                    
                    tipLabel.frame.origin.y = 0
                    
                }, completion: { (true) in
                    
                    tipLabel.removeFromSuperview()
                    
                })
                
            }
        }

}


