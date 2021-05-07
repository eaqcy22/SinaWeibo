//
//  ZTTabBarController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/4.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       let ztbar = ZTTabbar()
       
        ztbar.barClosure = {
        
            print(1)
        
        }
       setValue(ztbar, forKey: "tabBar")
        //添加子控制器
       addChildViewControllers()
        
    }
//添加子控制器方法
    func addChildViewControllers() {
        
        addChildViewController(addChildVC(vc: ZTHomeTableViewController(), imgName: "tabbar_home", title: "首页"))
        
        addChildViewController(addChildVC(vc: ZTMessageTableViewController(), imgName: "tabbar_message_center", title: "消息"))
        
        addChildViewController(addChildVC(vc: ZTDiscoverTableViewController(), imgName: "tabbar_discover", title: "发现"))
        
        addChildViewController(addChildVC(vc: ZTProfileTableViewController(), imgName: "tabbar_profile", title: "我的"))
    }
//添加单个子控制器
    func addChildVC(vc:UITableViewController,imgName:String,title:String) -> UINavigationController {
        
        let nav = ZTBaseNavController(rootViewController: vc)
        
        vc.title = title
        
        vc.tabBarItem.image = UIImage(imageLiteralResourceName: imgName).withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: imgName + "_selected").withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)
        
        return nav
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
