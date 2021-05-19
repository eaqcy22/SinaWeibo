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
       
        ztbar.barClosure = {[weak self] in
            
            let compose = ZTComposeView(frame: CGRect(x: 0, y: 0, width: screen_width, height: UIScreen.main.bounds.height))
            
            compose.show(fromVC: self)
        }
       setValue(ztbar, forKey: "tabBar")
        //添加子控制器
       addChildViewControllers()
        
    }
//添加子控制器方法
    func addChildViewControllers() {
        
        addChildViewController(addChildVC(vc: ZTHomeTableViewController(), imgName: "tabbar_home", title: "首页", index: 0))
        
        addChildViewController(addChildVC(vc: ZTMessageTableViewController(), imgName: "tabbar_message_center", title: "消息", index: 1))
        
        addChildViewController(addChildVC(vc: ZTDiscoverTableViewController(), imgName: "tabbar_discover", title: "发现", index: 2))
        
        addChildViewController(addChildVC(vc: ZTProfileTableViewController(), imgName: "tabbar_profile", title: "我的", index: 3))
    }
//添加单个子控制器
    func addChildVC(vc:UITableViewController,imgName:String,title:String,index:Int) -> UINavigationController {
        
        let nav = ZTBaseNavController(rootViewController: vc)
        
        vc.title = title
        //传递tag值
        vc.tabBarItem.tag = index
        
        vc.tabBarItem.image = UIImage(imageLiteralResourceName: imgName).withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: imgName + "_selected").withRenderingMode(.alwaysOriginal)
        
        vc.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)
        
        return nav
    }
    //选中item的方法
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item.tag)
        //需要获取被点击的tabbarButton
        //遍历子视图
        let tab = tabBar.subviews
        
        var index = 0
        
        for subView in tab {
            if subView.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                if index == item.tag {
                    print(subView)
                    //找到对应的button的情况
                    for v in subView.subviews {
                        //遍历button的子视图
                        if v.isKind(of: NSClassFromString("UITabBarSwappableImageView")!){
                        
                            print(v,"找到了!")
                            //找到了对应的imageV的控件
                            //做动画
                            v.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                            UIView.animate(withDuration: 0.5, delay: 0, options: [UIViewAnimationOptions(rawValue: 0)], animations: {
                                
                                v.transform = CGAffineTransform.identity
                                
                            }, completion: { (true) in
                                
                                print("ok")
                            })
                        }
                    }
                }
                index += 1
            }
        }
        
        
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
