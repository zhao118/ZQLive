//
//  PlayCycleViewCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/7.
//

import UIKit
import Kingfisher

class PlayCycleViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var playCycleModel: PlayCycleModel? {
        
        didSet{
            
            //roo_list里面有四个对象,使用第一对象的数据
            let imageURL = URL(string:playCycleModel!.room_list[0].room_src ?? "")!

            imageView.kf.setImage(with: imageURL)
            
            titleLabel.text = playCycleModel?.tag_name ?? "nihao"
            
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    

}
