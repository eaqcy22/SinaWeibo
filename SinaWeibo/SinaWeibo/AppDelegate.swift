//
//  AppDelegate.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/4.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame:UIScreen.main.bounds)
        
        //注册监听
        registNotification()
        
        window?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        window?.rootViewController = defaultViewController()
        
        window?.makeKeyAndVisible()
        
        return true
    }
    //MARK: 通知相关
    //注册通知
    private func registNotification(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(changeRootViewController(n:)), name: NSNotification.Name.AppChangeRootViewController, object: nil)
    }
    //接收通知改变根视图方法
    @objc private func changeRootViewController(n:Notification){

        let vcName = n.object as! String
        
        let productName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        
        let className = productName + "." + vcName
        
        let rootVCType = NSClassFromString(className) as! UIViewController.Type
        
        window?.rootViewController = rootVCType.init()
        
    }
    //移除通知监听,这里没有意义,仅仅是为了规范
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    private func defaultViewController() -> (UIViewController){
    
        return ZTUserAccountViewModel.shared.userLogin ? ZTWelcomeViewController() : ZTTabBarController()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

