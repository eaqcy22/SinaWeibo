//
//  ZTTabbar.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/4.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTTabbar: UITabBar {

    var barClosure:(() -> ())?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
       // fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        
        setUpUI()
        
    }
    func setUpUI() {
        
        addBtn.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        
        addSubview(addBtn)
        
    }
    //点击事件
    func clickAddBtn() {
        
        barClosure?()
        
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = bounds.size.width / 5
        
        let h = bounds.size.height
        
        var index = 0
        
        for subview in subviews{
        
            if subview.isKind(of:NSClassFromString("UITabBarButton")!) {
                //设置frame
                subview.frame = CGRect(x: CGFloat(index) * w, y: 0, width: w, height: h)
                
                index += (index == 1 ? 2 : 1)
            }
        }
        addBtn.center = CGPoint(x: center.x, y: h * 0.5)
        
        addBtn.bounds.size = CGSize(width: w, height: h)
    }
   //懒加载button
    lazy var addBtn:UIButton = {
    
        let btn = UIButton()
        
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add"), for: .normal)
        
        btn.setImage(#imageLiteral(resourceName: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "tabbar_compose_button"), for: .normal)
        
    //    btn.sizeToFit()
        
        return btn
        
    }()
}
