//
//  ZTWelcomeViewController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/9.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTWelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        setUpUI()
    }
    //UI搭建
    func setUpUI() {
        
        view.addSubview(iv_headIcon)
        
        view.addSubview(lb_welcome)
        
        iv_headIcon.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self.view)
            
            make.bottom.equalTo(self.view).offset(-180)
            
            make.size.equalTo(CGSize(width: 90, height: 90))
            
        }
        
        lb_welcome.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(iv_headIcon)
            
            make.top.equalTo(iv_headIcon.snp.bottom).offset(20)
            
        }
        
        iv_headIcon.layer.cornerRadius = 45
        
        iv_headIcon.layer.masksToBounds = true
        
        iv_headIcon.setImageWith(ZTUserAccountViewModel.shared.url!)
        
    }
    lazy var iv_headIcon : UIImageView = UIImageView(image: #imageLiteral(resourceName: "avatar_default"))
    
    lazy var lb_welcome : UILabel = {
        
        let l = UILabel(text: "欢迎回来\(ZTUserAccountViewModel.shared.userAccount?.screen_name ?? "")", font: 14, alignment: .center, preferWidth: 200, lines: 0, color: UIColor.darkGray)
        
        l.alpha = 0
        
        return l
    }()

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    //动画
    private func startAnimation(){
    
        iv_headIcon.snp.remakeConstraints { (make) in
            
            make.centerX.equalTo(self.view)
            
            make.top.equalTo(self.view).offset(180)
            
            make.size.equalTo(CGSize(width: 90, height: 90))
            
        }
        
        UIView.animate(withDuration: 1.5, delay: 0, options: [], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (_) in

            UIView.animate(withDuration: 1, animations: {
                
                self.lb_welcome.alpha = 1

            }, completion: { (_) in

                //动画欢迎完毕切换到tabbarVC
                //通知appdelegate切换根视图
                NotificationCenter.default.post(name: NSNotification.Name.AppChangeRootViewController, object: "ZTTabBarController")
                
            })
        }
    }
}
