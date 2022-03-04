//
//  CollectionHeaderView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/11.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - 定义模型属性
    //存储属性监听,若属性发生改变,就设置titleLabel.d21
    var group: AnchorGroup? {
        didSet {
            titleLabel.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "morentupian")
        }
    }
}

extension CollectionHeaderView {
    //快速创建CollectionHeaderView对象的方法,从XIB中加载
    class func collectionHeaderView() -> CollectionHeaderView{
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
