//
//  ZTOAuthViewController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/8.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

class ZTOAuthViewController: UIViewController{

    let webView = UIWebView()
    override func loadView() {
        
        view = webView
        
        //MARK: webView的代理
        webView.delegate = self
    }
    
    func clickClose() {
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    func clickFull() {
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('userId').value = 'yiyuxuan007@qq.com'")
        
        webView.stringByEvaluatingJavaScript(from: "document.getElementById('passwd').value = 'q40450490'")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", imgName: nil, target: self, action: #selector(clickClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "走后门", imgName: nil, target: self, action: #selector(clickFull))
        
        loadPage()

    }
    //MARK: 加载授权页面
    func loadPage() {
        
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        
        let req = URLRequest(url: URL(string: urlString)!)
        
        webView.loadRequest(req)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: WebView代理

extension ZTOAuthViewController:UIWebViewDelegate{
    
    //MARK: HUD展示
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
    //MARK: webView的代理方法
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.url?.absoluteString ?? ""
        let flag = "code="
        //判断是否是我们需要的授权返回页面
        if urlString.contains(flag) {
            
            let quary =  request.url?.query ?? ""
            
            let code = (quary as NSString).substring(from: flag.characters.count)
            
            print(code)
            //获取令牌
            ZTUserAccountViewModel.shared.loadAccessToken(code: code, finished: { (isLogin) in
                if !isLogin{
                    print("登录失败")
                }
                
                print("登录成功")
                //切换到欢迎页面
                //通知appdelegate切换根视图
                NotificationCenter.default.post(name: NSNotification.Name.AppChangeRootViewController, object: "ZTWelcomeViewController")
            })
            //在截取到code后 不让webView继续加载网页 阻止用户进一步乱跳网页            
            return false
        }
        
        return true
    }
}
