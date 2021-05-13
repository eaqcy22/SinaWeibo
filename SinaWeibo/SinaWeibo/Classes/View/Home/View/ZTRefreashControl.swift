//
//  ZTRefreashControl.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/11.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  该页面为自定义的RreashControl控件

import UIKit
private let refreashHight = 60
class ZTRefreashControl: UIControl {

    
    override init(frame: CGRect) {
        
        
        let rect : CGRect = CGRect(x: 0, y: -refreashHight, width: Int(screen_width), height: refreashHight)
        
        super.init(frame: rect)
        
        self.backgroundColor = UIColor.randomColor
        
        setupUI()
        
    }
    //UI设置
    func setupUI() {
        
        addSubview(lb_tip)
        
        addSubview(iv_arrow)
        
        addSubview(indicator)
        
        lb_tip.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self).offset(10)
            
            make.centerY.equalTo(self)
            
        }
        
        iv_arrow.snp.makeConstraints { (make) in
            
            make.right.equalTo(lb_tip.snp.left).offset(-5)
            
            make.centerY.equalTo(lb_tip)
            
        }
        indicator.snp.makeConstraints { (make) in
            
            make.center.equalTo(iv_arrow)
            
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //添加观察者
    override func willMove(toSuperview newSuperview: UIView?) {
        
        fatherView = newSuperview as! UIScrollView?
        
        fatherView?.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
    }
    //监听方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //查看监听值的变化
        print(change)
        
    }
    //懒加载控件
   private lazy var lb_tip : UILabel = UILabel(text: "下拉起飞", font: 14, alignment: .center, preferWidth: 150, lines: 0, color: UIColor.orange)
    
   private lazy var iv_arrow : UIImageView = UIImageView(image: #imageLiteral(resourceName: "tableview_pull_refresh"))
    
   private lazy var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
   //父视图
    private var fatherView:UIScrollView?
   //析构方法
    deinit {
        fatherView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}
