//
//  CollectionHeaderView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/11.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

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
