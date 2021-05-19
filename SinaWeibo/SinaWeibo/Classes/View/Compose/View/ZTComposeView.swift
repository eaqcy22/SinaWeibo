
//
//  ZTComposeView.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/13.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

import pop

class ZTComposeView: UIView {

    //懒加载button数组
    lazy var buttonArray:[ZTComposeButton] = [ZTComposeButton]()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
        
        addButton()
        
        
      //  backgroundColor = UIColor.red
    }
    override func removeFromSuperview() {
        
        super.removeFromSuperview()
    }
    
    func removeDeleteSuperV() {
        
        self.removeFromSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 //MARK: UI设置
    private func setupUI(){
        //截取当前屏幕成为背景视图
        //高斯处理第1种
        let iv = UIImageView(image:UIImage.getCurrentScreenImage().applyTintEffect(with: UIColor.purple))
        
        self.addSubview(iv)
        //处理高斯模糊 第2种方式
//        let tooBar = UIToolbar(frame: UIScreen.main.bounds)
//        
//        self.addSubview(tooBar)
        let sloganIv = UIImageView(image: #imageLiteral(resourceName: "compose_slogan"))
        
        self.addSubview(sloganIv)
        
        sloganIv.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            
            make.top.equalTo(self).offset(100)
        }
    }
    //MARK: 按钮选中的方法
    @objc private func didClickComposeBtn(btn:ZTComposeButton){
        
        UIView.animate(withDuration: 0.5, animations: {
            //遍历数组取出需要找到的button
            for composeBtn in self.buttonArray{
            
                if btn == composeBtn{
                    //动画按钮放大
                    composeBtn.transform = CGAffineTransform(scaleX: 2, y: 2)
                    
                    composeBtn.alpha = 0.1
                    
                }else{
                    //其余按钮缩小
                    composeBtn.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                    
                    composeBtn.alpha = 0.1
                }
                
            }
            
        }) { (_) in
            
            //完成动画跳转控制器
            let className = "SinaWeibo.ZTComposeViewController"
            
            guard let classType = NSClassFromString(className) as? UIViewController.Type else{
            
                return
            }
            let composeVC = classType.init()
            
            let nav = UINavigationController.init(rootViewController: composeVC)
            
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        
            self.removeFromSuperview()
        
        }
        
        

        
    }
//MARK: 添加button
    private func addButton(){
    
        //计算button间距
        let btnMargin = (screen_width - 3 * composeBtnW) / 4
        
        let images = [#imageLiteral(resourceName: "tabbar_compose_lbs"),#imageLiteral(resourceName: "tabbar_compose_idea"),#imageLiteral(resourceName: "tabbar_compose_photo"),#imageLiteral(resourceName: "tabbar_compose_music"),#imageLiteral(resourceName: "tabbar_compose_friend"),#imageLiteral(resourceName: "tabbar_compose_more")]
        for i in 0 ..< images.count{
        
            let row = i / 3
            
            let col = i % 3
            
            let btnX = btnMargin + (btnMargin + composeBtnW) * CGFloat(col)
            
            let btnY = (btnMargin + composeBtnH) * CGFloat(row)
            
            let btn = ZTComposeButton()
            
            btn.setTitle("测试", for: .normal)
            
            btn.setImage(images[i], for: .normal)
            
            btn.frame = CGRect(x: btnX, y: btnY+screen_hight, width: composeBtnW, height: composeBtnH)
            
            btn.addTarget(self, action: #selector(didClickComposeBtn(btn:)), for: .touchUpInside)
            
            buttonArray.append(btn)
            
            self.addSubview(btn)
        }
    }
    //MARK: 实现pop动画
    private func startAnimation(btn:ZTComposeButton,index:Double,isShow:Bool){
        
            let springAnimation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            //设置属性
            springAnimation?.springSpeed = 8
            
            springAnimation?.springBounciness = 10
            
            springAnimation?.beginTime = CACurrentMediaTime() + Double(index) * 0.025
        
            let btnCenterY = btn.center.y + CGFloat(isShow ? -350 : 350)
        
            springAnimation?.toValue = CGPoint(x: btn.center.x, y: btnCenterY)
            
            btn.pop_add(springAnimation, forKey: nil)
    }
    //自定义展示自己的方法
    func show(fromVC:UIViewController?){
        
        fromVC?.view.addSubview(self)
        
        for (index,btn) in buttonArray.reversed().enumerated(){
            
            self.startAnimation(btn: btn, index: Double(index),isShow:true)
            
        }
    }
    //触摸屏幕退出视图
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //动画退出
        for (index,btn) in buttonArray.reversed().enumerated(){
            
            self.startAnimation(btn: btn, index: Double(index),isShow:false)
            
        }
        //延时两秒退出
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            
            self.removeFromSuperview()
        }        
    }
}
