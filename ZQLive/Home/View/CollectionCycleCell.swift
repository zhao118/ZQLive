//
//  CollectionCycleCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/28.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var cycleModel2: CycleModel2? {
        //自定义CollectionCycleCell.d25
        //监听RecommendCycleView中数据源中的cycleModel值的改变
        didSet{
            
            titleLabel.text = cycleModel2?.title
            
            let iconURL = URL(string: cycleModel2?.pic_url ?? "")
            //使用Kingfisher加载网络图片.也可以使用可以设置占位符的API
            //iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: kDouYu))
            iconImageView.kf.setImage(with: iconURL)
            
            
        }
    }
    
}
