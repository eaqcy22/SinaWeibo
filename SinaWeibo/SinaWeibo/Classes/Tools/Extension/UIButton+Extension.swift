//
//  UIButton+Extension.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/6.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

extension UIButton{
    
    convenience init(title: String,imgName: String,target: Any?,action: Selector?) {
        
        self.init()
        
        self.setBackgroundImage(UIImage(named:imgName), for: .normal)
        
        self.setTitle(title, for: .normal)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.setTitleColor(UIColor.orange, for: .highlighted)
        
        self.addTarget(target, action: action!, for: .touchUpInside)

    }
    
}
