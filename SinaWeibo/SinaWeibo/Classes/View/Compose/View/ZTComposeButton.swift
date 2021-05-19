//
//  ZTComposeButton.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/14.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
let composeBtnW:CGFloat = 80
let composeBtnH:CGFloat = 110
class ZTComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        //UI设置
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(UIColor.darkGray, for: .normal)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: composeBtnW, width: composeBtnW, height: composeBtnH-composeBtnW)
    }
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: composeBtnW, height: composeBtnW)
    }
}
