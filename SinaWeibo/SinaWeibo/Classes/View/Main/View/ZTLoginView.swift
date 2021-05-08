//
//  ZTLoginView.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/6.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
import SnapKit
//MARK: 代理协议
protocol LoginViewDelegate:NSObjectProtocol {
    
    func userWillLogin()
    
    func userWillRegist()
    
}
class ZTLoginView: UIView {

    //代理属性
    weak var delegate:LoginViewDelegate?
    //MARK: 控件懒加载
    //label
    lazy var lb_title:UILabel = UILabel(text: "关注一些人到这里看看有什么惊喜", font: CGFloat(14), alignment: .center, preferWidth: 220, lines: 0, color: UIColor.black)
    //添加大房子
    lazy var houseV = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_house"))
    //添加圈圈
    lazy var circleV = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_image_smallicon"))
    //添加遮罩
    lazy var coverV = UIImageView(image: #imageLiteral(resourceName: "visitordiscover_feed_mask_smallicon"))
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    
    self.backgroundColor = UIColor(white: 237 / 255.0, alpha: 1)
    
    setUpUI()
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //初始化UI
    func setUpUI() {
        
        addSubview(circleV)
        
        circleV.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            
            make.centerY.equalTo(self).offset(-80)
            
        }
        
        
        addSubview(coverV)
        
        coverV.snp.makeConstraints { (make) in
            
            make.edges.equalTo(circleV)
            
        }
        
        addSubview(houseV)
        
        houseV.snp.makeConstraints { (make) in
            
            make.center.equalTo(circleV)
            
        }
      
        addSubview(lb_title)
        
        lb_title.snp.makeConstraints { (make) in
            
            make.top.equalTo(coverV.snp.bottom).offset(10)
            
            make.centerX.equalTo(self)
            
        }
        //添加两个按钮
        let btn_Login = UIButton(title: "登录", imgName: "common_button_white", target: self, action: #selector(clickLogin))
        
        addSubview(btn_Login)
        
        btn_Login.snp.makeConstraints { (make) in
            
            make.top.equalTo(lb_title.snp.bottom).offset(10)
            
            make.left.equalTo(lb_title)
            
            make.width.equalTo(80)
        }
        
        let btn_regist = UIButton(title: "注册", imgName: "common_button_white", target: self, action: #selector(clickRegist))
        
        addSubview(btn_regist)
        
        btn_regist.snp.makeConstraints { (make) in
            
            make.top.equalTo(lb_title.snp.bottom).offset(10)
            
            make.right.equalTo(lb_title)
            
            make.width.equalTo(80)
        }
    }
    //MARK 暴露更改属性方法
    func changeLoginView(imageName: String,title: String,isHome: Bool){
        
        if isHome == false {
            
            circleV.image = UIImage(named: imageName)
            
            lb_title.text = title
            
            houseV.isHidden = true
            
            coverV.isHidden = true
            
        }else{
        
            animate()
        }
    }
    func animate() {
        //MARK: 圈圈动画
        let animator:CABasicAnimation = CABasicAnimation()
        
        animator.keyPath = "transform.rotation"
        
        animator.toValue = M_PI * 2
        
        animator.repeatCount = MAXFLOAT
        
        animator.duration = 10
        
        animator.isRemovedOnCompletion = false
        
        circleV.layer.add(animator, forKey: nil)
    }
    //MARK: 按钮点击
    func clickLogin() {
        
        delegate?.userWillLogin()
        
    }
    func clickRegist() {
        
        delegate?.userWillRegist()
        
    }
}
