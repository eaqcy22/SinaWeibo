//
//  UILabel+Extension.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/6.
//  Copyright © 2017年 sharayuki. All rights reserved.
/*


 */

import UIKit

extension UILabel{

    convenience init(text: String,font: CGFloat,alignment: NSTextAlignment,preferWidth: CGFloat,lines: Int,color: UIColor) {
        
        self.init()
        
        self.text = text
        
        self.font = UIFont.systemFont(ofSize: font)
        
        self.textAlignment = alignment
        
        self.preferredMaxLayoutWidth = preferWidth
        
        self.numberOfLines = lines
        
    }

}
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
extension UIColor{

    class var randomColor : UIColor{
     
        let r = CGFloat(arc4random_uniform(256)) / 255.0
        let g = CGFloat(arc4random_uniform(256)) / 255.0
        let b = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}
