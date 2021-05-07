//
//  ZTBaseNavController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/5.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTBaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        //判断子视图个数是否大于0 如果大于0 说明不是根视图
        let count = self.childViewControllers.count
        if count > 0 {
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", imgName: "navigationbar_back_withtext", target: self, action: #selector(clickBack))
            
           viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    func clickBack() {
        
        self.popViewController(animated: true)
        
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
