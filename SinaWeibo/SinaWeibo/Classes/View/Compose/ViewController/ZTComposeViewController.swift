//
//  ZTComposeViewController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/14.
//  Copyright © 2017年 sharayuki. All rights reserved.
//  发布微博的控制器

import UIKit
import SVProgressHUD

class ZTComposeViewController: UIViewController {

    //微博底部工具栏枚举
    enum WeiboType : Int {
        case kPhoto = 0
        case kAtSome
        case kTopic
        case kEmotion
        case kMore
    }
    lazy var picVC : ZTPictureSelectorController = {
        
        let l = UICollectionViewFlowLayout()
        
        l.itemSize = CGSize(width: picItemWidth, height: picItemWidth)
        
        l.minimumLineSpacing = cellMargin
        
        l.minimumInteritemSpacing = cellMargin
        
        l.sectionInset = UIEdgeInsetsMake(cellMargin, cellMargin, 0, cellMargin)
        
        let p = ZTPictureSelectorController(collectionViewLayout: l)
        
        return p
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // view.backgroundColor = UIColor.orange
        
        setupUI()
        
        registNotificate()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    //注册通知
    private func registNotificate(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillChange(n:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
    }
    @objc private func keybordWillChange(n:Notification){
    
        let dict = n.userInfo as! [String:Any]
        
        let endFrame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        
        let offsetY = -(screen_hight - endFrame.origin.y)
        
        UIView.animate(withDuration: 0.25) {
            
            self.toolBar.snp.updateConstraints { (make) in
                
                make.bottom.equalTo(self.view).offset(offsetY)
            }
            
            self.view.layoutIfNeeded()
            
        }
        
    }
    private func setupUI(){
    
        setNavBar()
        
        view.addSubview(textView)
        
        textView.delegate = self
        
        textView.snp.makeConstraints { (make) in
            
            make.top.left.right.equalTo(self.view)
            
            make.height.equalTo(screen_hight / 3)
        }
        textView.addSubview(placeHolderLabel)
        
        placeHolderLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(textView).offset(8)
            
            make.left.equalTo(textView).offset(5)
        }
        view.addSubview(toolBar)
        
        toolBar.snp.makeConstraints { (make) in
            
            make.bottom.left.right.equalTo(self.view)
            
            make.height.equalTo(40)
        }
        //添加图片选择器
        self.addChildViewController(picVC)//该控制器强引用picVC
        
        view.addSubview(picVC.view)
        //设置约束
        picVC.view.snp.makeConstraints { (make) in
            
            make.bottom.left.right.equalTo(self.view)
            
            make.height.equalTo(screen_hight * 2 / 3)
        }
        picVC.view.isHidden = true
        //将toolBar设置为图层顶部
        self.view.bringSubview(toFront: toolBar)
    }
    //设置navigationBar
    private func setNavBar(){
    
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(clickClose))
        
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = sendItem
        
        //富文本自定义titleView
        
        let titleLabel = UILabel()
        
        titleLabel.textAlignment = .center
        
        if let name = ZTUserAccountViewModel.shared.userAccount?.screen_name{
        
            let titleText = "发布微博\n\(name)"
            
            titleLabel.text = titleText
            
            titleLabel.numberOfLines = 0
            
            let strM = NSMutableAttributedString(string: titleText)
            
            let range = (titleText as NSString).range(of: name)
            
            strM.addAttributes([NSForegroundColorAttributeName : UIColor.orange,NSFontAttributeName : UIFont.systemFont(ofSize: 14)], range: range)
            
            titleLabel.attributedText = strM
            
        }else{
        
            titleLabel.text = "发布微博"
        }
        titleLabel.sizeToFit()
        
        self.navigationItem.titleView = titleLabel
        
    }
    //点击退出
    @objc private func clickClose() {
        
        dismiss(animated: true, completion: nil)
        
    }
    //MARK: 发布微博方法
    @objc private func sendWeibo(){
        
        textView.endEditing(true)
        
        var urlString = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        guard let accesstoken = ZTUserAccountViewModel.shared.access_token else {
            
            return
        }
        
        let parametor : [String:Any] = ["access_token":accesstoken,"status":textView.text]
        
        if picVC.images.count == 0 {
            
            //文本微博
            urlString = "https://api.weibo.com/2/statuses/update.json"
            
            ZTNetworkTool.shared.request(urlString: urlString, method: .POST, parametor: parametor) { (req, error) in
                
                if error != nil{
                    
                    SVProgressHUD.showError(withStatus: "发布微博失败")
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "发布微博成功")
            }
        }else{
        
            //图片微博
            ZTNetworkTool.shared.post(urlString, parameters: parametor, constructingBodyWith: { (formData) in
                
                let image = self.picVC.images.last!
                
                let imageData = UIImagePNGRepresentation(image)
                
                formData.appendPart(withFileData: imageData!, name: "pic", fileName: "xxxx", mimeType: "application/octet-stream")
            }, progress: nil, success: { (_, resp) in
                
                SVProgressHUD.showSuccess(withStatus: "发表微博成功")
            }) { (_, error) in
                SVProgressHUD.showError(withStatus: "发布微博失败")
                return
            }
        }
    }
    //MARK: 点击toobar的方法
    @objc private func weiboTypeBtnDidClick(btn: UIButton){
       
        let type = WeiboType(rawValue: btn.tag)!
        
        switch type {
        case .kPhoto:
           print("图片")
           picVC.view.isHidden = false
        case .kAtSome:
            print("@某人")
        case .kTopic:
            print("主题")
        case .kEmotion:
            print("表情")
        case .kMore:
            print("更多")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //懒加载barButtonItem
    lazy var sendItem:UIBarButtonItem = {
    
        let btn = UIButton()
        
        btn.setTitle("发送", for: .normal)
        
        btn.setTitleColor(UIColor.white, for: .normal)
        
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_white"), for: .disabled)
        
        btn.setBackgroundImage(#imageLiteral(resourceName: "common_button_orange"), for: .normal)
        
        btn.addTarget(self, action: #selector(sendWeibo), for: .touchUpInside)
        
        btn.sizeToFit()
        
        btn.bounds.size.width = 60

        let barItem = UIBarButtonItem(customView: btn)
        
        barItem.isEnabled = false
        
        return barItem
    }()
    //懒加载textView
    lazy var textView: UITextView = {
    
        let tv = UITextView()
        
        tv.backgroundColor = UIColor.randomColor
        
        tv.font = UIFont.systemFont(ofSize: 18)
        
        return tv
    }()
    //懒加载占位文本
    lazy var placeHolderLabel : UILabel = {
    
        let lb = UILabel()
        
        lb.text = "听说下雨天巧克力和音乐更配哟!"
        
        lb.font = UIFont.systemFont(ofSize: 18)
        
        lb.textColor = UIColor.lightGray
        
        return lb
    }()
    //懒加载底部工具栏2
    lazy var toolBar:UIStackView = {
    
        let t = UIStackView()
        
        t.axis = .horizontal
        
        t.distribution = .fillEqually
        
        let images = ["compose_toolbar_picture",
                      "compose_mentionbutton_background",
                      "compose_trendbutton_background",
                      "compose_emoticonbutton_background",
                      "compose_add_background"]
        for (offset,image) in images.enumerated(){
        
            let b = UIButton()
            
            b.tag = offset
            
            b.setImage(UIImage(named:image), for: .normal)
            
            b.setImage(UIImage(named:image + "_highlighted"), for: .highlighted)
            
            b.addTarget(self, action: #selector(weiboTypeBtnDidClick(btn:)), for: .touchUpInside)
            
            b.backgroundColor = UIColor(white: 0.95, alpha: 1)
            
            t.addArrangedSubview(b)
        }
        return t
    }()
    
    //点击屏幕结束编辑
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        textView.endEditing(true)
    }
    deinit {
    
        NotificationCenter.default.removeObserver(self)
        
    }
}
extension ZTComposeViewController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        //判断发布按钮的状态
        sendItem.isEnabled = textView.hasText
        
        //占位文本的隐藏与否
        placeHolderLabel.isHidden = textView.hasText
    }
    
}
