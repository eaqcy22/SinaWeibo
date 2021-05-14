//
//  ZTRefreashControl.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/11.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  该页面为自定义的RreashControl控件

import UIKit
private let refreashHight : CGFloat = 60
//刷新状态枚举
enum RefreashState: Int {
    case kStateNormal = 1
    case kStateReady
    case kStateRefreash
}
class ZTRefreashControl: UIControl {

    var refreashState:RefreashState = .kStateNormal{
        
        didSet{
            
            switch refreashState {
            case .kStateNormal:
                print("state普通状态")
                lb_tip.text = "下拉看胖次"
                iv_arrow.isHidden = false
                indicator.stopAnimating()
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.iv_arrow.transform = CGAffineTransform.identity
                })
                //悬停消失
                if oldValue == .kStateRefreash{
                
                    UIView.animate(withDuration: 0.5, animations: {
                        
                       self.fatherView!.contentInset.top = self.fatherView!.contentInset.top - refreashHight

                    })
                }
                case .kStateReady:
                lb_tip.text = "胖次就快看到了!"
                UIView.animate(withDuration: 0.5, animations: { 
                    
                    self.iv_arrow.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                })
                print("state准备状态")
            case .kStateRefreash:
                lb_tip.text = "想什么呢?hentai!"
                iv_arrow.isHidden = true
                indicator.startAnimating()
                sendActions(for: .valueChanged)
                print("state刷新状态")
                //悬停效果
                fatherView!.contentInset.top = fatherView!.contentInset.top + refreashHight
            }
        }
    }
    override init(frame: CGRect) {
        
        let rect : CGRect = CGRect(x: 0, y: -refreashHight, width: screen_width, height: refreashHight)
        
        super.init(frame: rect)
        
        self.backgroundColor = UIColor.randomColor
        
        setupUI()
        
    }
    //UI设置
    func setupUI() {
        
        addSubview(iv_back)
        
        addSubview(lb_tip)
        
        addSubview(iv_arrow)
        
        addSubview(indicator)
        
        iv_back.snp.makeConstraints { (make) in
            
            make.bottom.left.right.equalTo(self)
        }
        
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
        //print(change)
        //取到偏移量
        let offY = self.fatherView?.contentOffset.y ?? 0
        
        let targetY = -(self.fatherView!.contentInset.top + refreashHight)
        //如果被拖动
        if self.fatherView!.isDragging{
            //进入准备刷新状态
            if refreashState == .kStateNormal && offY < targetY{
                print(offY,targetY)
                refreashState = .kStateReady
                //回到普通状态
            }else if refreashState == .kStateReady && offY > targetY{
            
                refreashState = .kStateNormal
            }
            
        }else{
            //开始刷新
            if refreashState == .kStateReady {
                
                refreashState = .kStateRefreash
            }
        }
        
    }
    func endRreashing(){
    //延时恢复
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.refreashState = .kStateNormal
        }
    }
    //懒加载控件
   private lazy var lb_tip : UILabel = UILabel(text: "下拉起飞", font: 14, alignment: .center, preferWidth: 150, lines: 0, color: UIColor.orange)
    
   private lazy var iv_arrow : UIImageView = UIImageView(image: #imageLiteral(resourceName: "tableview_pull_refresh"))
    
   private lazy var indicator : UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
    private lazy var iv_back : UIImageView = UIImageView(image: #imageLiteral(resourceName: "panci"))
   //父视图
    private var fatherView:UIScrollView?
   //析构方法
    deinit {
        fatherView?.removeObserver(self, forKeyPath: "contentOffset")
    }
}
