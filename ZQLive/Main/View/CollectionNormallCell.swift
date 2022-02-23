//
//  CollectionNormallCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/11.
//

import UIKit

//制作普通的cell
//主页的推荐界面里面有两种样式(大小)的cell,分别注册并创建.小粉书中是注册一种cell再根据图片的大小定义cell的大小.d15
//CollectionPrettyCell与CollectionNormallCell中相同的地方都写在该类中,继承该类,让该类成为他们的父类.d22
class CollectionNormallCell: CollectionViewBaseCell {
    
    //MARK: - 控件的属性
    @IBOutlet weak var roomNameLabel: UILabel!
    
    //MARK: - 定义模型属性.d22
    //因为父类中已经定义有anchor属性了,这里再使用需要override覆写.d22
    override var anchor: AnchorModel? {
        
        didSet{
            //将子类中的anchor模型属性传递给父类,在父类中使用它进行属性的设置.d22
            super.anchor = anchor
            //房间名称
            roomNameLabel.text = anchor?.room_name
        }
    }
    
}
