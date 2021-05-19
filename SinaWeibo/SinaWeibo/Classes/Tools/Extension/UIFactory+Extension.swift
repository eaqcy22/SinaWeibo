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
        
        if let hilightImage = UIImage(named:imgName + "_highlighted"){
        
            self.setBackgroundImage(hilightImage, for: .highlighted)
            
            print(hilightImage)
        }
        self.setTitle(title, for: .normal)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.setTitleColor(UIColor.lightGray, for: .normal)
        
        self.setTitleColor(UIColor.orange, for: .highlighted)
        
        if (target != nil && action != nil){
        
            self.addTarget(target, action: action!, for: .touchUpInside)

        }
        
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

extension UIImage{

    //获取当前屏幕图像的方法
    class func getCurrentScreenImage()->UIImage{
        //开启图形上下文
        let window = UIApplication.shared.keyWindow!
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0)
        //将window 绘制到图层中
        window.drawHierarchy(in: window.frame, afterScreenUpdates: true)
        //从上下文中获取图片对象
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        //返回结果
        return image!
        
    }
    func scaleImage(scaleWidth: CGFloat)-> UIImage{
    
        //获取当前图片的宽度和高度
        let imageW = self.size.width
        
        let imageH = self.size.height
        //判断是否需要缩放
        if imageW <= scaleWidth {
            
            return self
        }
        //如果需要缩放 则根据当前图片宽高比 计算出缩放后的高度
        let scaleH = imageH / imageW * scaleWidth
        
        let imageBounds = CGRect(x: 0, y: 0, width: scaleWidth, height: scaleH)
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(imageBounds.size, false, 0)
        //将图片对象绘制到图形上下文中
        self.draw(in: imageBounds)
        //获取缩放后的图形对象
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //返回图片 关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
}
