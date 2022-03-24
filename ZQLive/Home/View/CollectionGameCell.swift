//
//  CollectionGameCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/1.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var IconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
   
    //定义模型属性.d28
  
    var group: CycleModel2? {
        
        //监听属性的值的改变,由RecommendGameView中的数据源方法传递过来group的值
        didSet{
            
          
            titleLabel.text = group?.title
           
            let gameIconURL = URL(string: (group?.room?.game_icon_url ?? "")!)
            //设置一个占位符,当无法正常显示图片的时,显示占位符;或图片显示完时,最后一个图片显示占位符,.28
            IconImageView.kf.setImage(with: gameIconURL, placeholder: UIImage(named: "gengduo"))
            
            
        }
    }
    
    var group2: GameModel2? {
        
        //监听属性的值的改变,由RecommendGameView中的数据源方法传递过来group的值
        didSet{
            
            titleLabel.text = group2?.title
           
            let gameIconURL = URL(string: (group2?.room?.room_src ?? "")!)
            //设置一个占位符,当无法正常显示图片的时,显示占位符;或图片显示完时,最后一个图片显示占位符,.28
            IconImageView.kf.setImage(with: gameIconURL, placeholder: UIImage(named: "gengduo"))
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置图片的圆角.d28
        IconImageView.layer.cornerRadius = 25
       
        
    }

}
