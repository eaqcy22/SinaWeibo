//
//  UIBarButtonItem+Extension.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/5.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

extension UIBarButtonItem{

    convenience init(title: String,imgName: String,target: Any?,action: Selector?) {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named:imgName), for: .normal)
        
        btn.setImage(UIImage(named:imgName + "_highlighted"), for: .highlighted)
        
        btn.setTitle(title, for: .normal)
        
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        btn.setTitleColor(UIColor.orange, for: .highlighted)
        
        btn.addTarget(target, action: action!, for: .touchUpInside)
        
        btn.sizeToFit()
        
        self.init()
        
        self.customView = btn
        
    }

}
