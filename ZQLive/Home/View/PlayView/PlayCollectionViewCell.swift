//
//  PlayCollectionViewCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/8.
//

import UIKit
import Kingfisher

class PlayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var playModel: PlayModel? {
        
        didSet{
          
            //roo_list里面有四个对象,使用第二个对象的数据
            let imageURL = URL(string: playModel?.room_list[1].room_src ?? "")!
            imageView.kf.setImage(with: imageURL)
            
            titleLabel.text = playModel?.tag_name ?? "请求失败"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }

}
