//
//  ZTStatusCell.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
import SDWebImage

private let margin : CGFloat = 8//正文的间距

private let picWidthMargin : CGFloat = 2 //图片宽度间距

private let maxWidth:CGFloat = screen_width - 2 * margin//最大图片视图宽度

private let itemWidth : CGFloat = (maxWidth - 2 * picWidthMargin)/3//单张图片的宽度

class ZTStatusCell: UITableViewCell {
    //底部视图
    @IBOutlet weak var buttomView: UIStackView!
    //转发微博的正文label
    @IBOutlet weak var lb_retweentContent: UILabel?
    //图片视图顶部约束
    @IBOutlet weak var picViewTopCons: NSLayoutConstraint!
    //图片视图的layout
    @IBOutlet weak var FlowLayout: UICollectionViewFlowLayout!
    //图片视图高度
    @IBOutlet weak var picHight: NSLayoutConstraint!
    //图片视图宽度
    @IBOutlet weak var picWidth: NSLayoutConstraint!
    //图片视图
    @IBOutlet weak var picView: ZTPicCollectionView!
    //作者等级
    @IBOutlet weak var rankView: UIImageView!
    //作者头像
    @IBOutlet weak var headIcon: UIImageView!
    //作者名称
    @IBOutlet weak var lb_name: UILabel!
    //发布时间
    @IBOutlet weak var lb_time: UILabel!
    //发布源
    @IBOutlet weak var lb_source: UILabel!
    //微博正文
    @IBOutlet weak var lb_content: UILabel!
    //用户组
    @IBOutlet weak var verifiedIcon: UIImageView!
    
    var viewModel:ZTHomeCellModel?{
    
        didSet {
            //绑定数据
            lb_time.text = viewModel?.timeText
            
            lb_source.text = viewModel?.sourceText
            
            lb_content.text = viewModel?.status?.text
            
            lb_retweentContent?.text = viewModel?.status?.retweeted_status?.text
            
            lb_name.text = viewModel?.status?.user?.screen_name
            
            headIcon.sd_setImage(with: viewModel?.headURL)
            
            verifiedIcon.image = viewModel?.verifiedImage
            
            rankView.image = viewModel?.mbrankImage
            //设置图片视图宽高
            let count = viewModel?.imageInfo?.count ?? 0
          //  print(pSize)
            //修改图片视图的宽高
            let result = caclulatePicSize(count: count)
            
            let pSize = result.pSize
            
            picHight.constant = pSize.height
            
            picWidth.constant = pSize.width
                
            //设置图片视图的模型数组
            picView.pic_url = viewModel?.imageInfo
            //FlowLayout设置
            FlowLayout.itemSize = result.itemSize
                
            FlowLayout.minimumInteritemSpacing = CGFloat(picWidthMargin)
            
            FlowLayout.minimumLineSpacing = CGFloat(picWidthMargin)
            
            picViewTopCons.constant = (count == 0) ? 0 : 8
            
            self.layoutIfNeeded()
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //取消选中风格
        self.selectionStyle = .none
        //控件设置
        lb_content.numberOfLines = 0
        
        lb_content.preferredMaxLayoutWidth = screen_width - 2 * margin
        
        lb_retweentContent?.numberOfLines = 0
        
        lb_retweentContent?.preferredMaxLayoutWidth = screen_width - 2 * margin
        //picView.backgroundColor = UIColor.randomColor
        
    }
//图片宽高计算方法
    private func caclulatePicSize(count:Int) -> (pSize: CGSize,itemSize: CGSize){
        //没有图片
        if count == 0{
        
            return (CGSize.zero,CGSize.zero)
        }
        //单张图片 日后修改
        if count == 1{
            //计算图片的大小
            if let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: viewModel?.imageInfo?.last?.wap360 ?? ""){
                
                let imageSize = image.size
                
                return (imageSize,imageSize)
            }
            
            
            return (CGSize(width: itemWidth, height: itemWidth),CGSize(width: itemWidth, height: itemWidth))
        }
        //四张图片
        if count == 4{
        
            let width = itemWidth * 2.01 + picWidthMargin
            
            return (CGSize(width: width, height: width),CGSize(width: itemWidth, height: itemWidth))
        }
        
        //其他多张
        //计算行数
        let row  = Int(count - 1) / 3 + 1
        
        let hight = itemWidth * CGFloat(row) + picWidthMargin * CGFloat(row - 1)
        
        return (CGSize(width: maxWidth , height: hight),CGSize(width: itemWidth , height: itemWidth))
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
