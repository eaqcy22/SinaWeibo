//
//  ZTPicCollectionView.swift
//  SinaWeibo
//
//  Created by sharayuki on 2017/1/10.
//  Copyright © 2017年 sharayuki. All rights reserved.
//

import UIKit
private let picViewCellid = "ZTPicViewCell"
class ZTPicCollectionView: UICollectionView {

    var pic_url:[ZTPicInfo]?{
    
        didSet{
        
            self.reloadData()
        
        }
    
    }
    override func awakeFromNib() {
        
        register(ZTPicViewCell.self, forCellWithReuseIdentifier: picViewCellid)
        //设置数据源
        self.dataSource = self
        
    }

}

//数据源
extension ZTPicCollectionView : UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pic_url?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picViewCellid, for: indexPath) as! ZTPicViewCell
        
        cell.picInfo = pic_url![indexPath.item]
        
        return cell
    }

}
