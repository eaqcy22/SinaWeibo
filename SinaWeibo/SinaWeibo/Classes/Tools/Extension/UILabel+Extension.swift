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
