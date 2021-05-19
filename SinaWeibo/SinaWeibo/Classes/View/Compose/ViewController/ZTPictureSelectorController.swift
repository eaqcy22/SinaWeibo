//
//  ZTPictureSelectorController.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/16.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit

private let picSelectorCellid = "picSelectorCell"
let cellMargin : CGFloat = 4
private let colCount = 3
let picItemWidth = (screen_width - (3 + 1) * cellMargin)/CGFloat(colCount)
private let picSelectorItemMaxCount = 9
@objc protocol ZTPicSelectorCellDelegate:NSObjectProtocol{
    
    @objc optional func clickAddBtn()
    @objc optional func clickDelBtn(cell:ZTPicSelectorCell)
    
}
class ZTPicSelectorCell:UICollectionViewCell{
    
    weak var delegate:ZTPicSelectorCellDelegate?
    
    var image : UIImage?{
    
        didSet{

            addBtn.setImage(image, for: .normal)
            
            delBtn.isHidden = image == nil
       }
    }
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
                
        contentView.addSubview(addBtn)
        
        contentView.addSubview(delBtn)
        //约束
        addBtn.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.contentView)
        }
        delBtn.snp.makeConstraints { (make) in
            
            make.top.right.equalTo(self.contentView)
        }
        addBtn.imageView?.contentMode = .scaleAspectFill
        
    }
    func didClickAdd(){
        //判断是否需要添加
        if image != nil{
        
            return
        }
        delegate?.clickAddBtn?()
    }
    func didClickDel(){
        
        delegate?.clickDelBtn?(cell: self)
    }
    lazy var addBtn:UIButton = {
        
        let b = UIButton(title: "", imgName: "compose_pic_add", target: self, action: #selector(didClickAdd))
        
        return b
    }()
    lazy var delBtn:UIButton = {
        
        let b = UIButton(title: "", imgName: "compose_photo_close", target: self, action: #selector(didClickDel))
        
        return b
    }()
}
extension ZTPictureSelectorController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        //取出图片 并缩放后添加
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage).scaleImage(scaleWidth: 600)
        //追加图片
        print("----",image)
        
        images.append(image)
        
        print("+++++",images,"--",image)
        //刷新数据
        collectionView?.reloadData()
        //在实现picker的该代理方法后,需要手动dismiss
        dismiss(animated: true, completion: nil)
    }
}
class ZTPictureSelectorController: UICollectionViewController,ZTPicSelectorCellDelegate{
    //保存图片的数组
    lazy var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView?.backgroundColor = UIColor.white
        
        self.collectionView!.register(ZTPicSelectorCell.self, forCellWithReuseIdentifier: picSelectorCellid)

        // Do any additional setup after loading the view.
    }
    func clickDelBtn(cell:ZTPicSelectorCell) {

        let indexPath = collectionView?.indexPath(for: cell)
        
        images.remove(at: indexPath!.item)
        
        if images.count == 0 {
            
            self.view.isHidden = true
        }
        
        collectionView?.reloadData()
        
        
    }
    func clickAddBtn() {

        //实例化图片选择器 并弹出
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //判断是否还能够添加图片
        let delta:Int = images.count == 9 ? 0 : 1
        return images.count + delta
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picSelectorCellid, for: indexPath) as! ZTPicSelectorCell
        
        if indexPath.item == images.count {
            
            cell.image = nil
        }else{
        
            cell.image = images[indexPath.item]
            
        }
        
        cell.backgroundColor = UIColor.white
        // Configure the cell
        cell.delegate = self
        
        return cell
    }

}
