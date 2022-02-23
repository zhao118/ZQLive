//
//  CollectionPrettyCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/11.
//

import UIKit
import Kingfisher


//自定义"颜值"里面的Cell比最上面的尺寸大一些
//CollectionPrettyCell与CollectionNormallCell中相同的地方都写在该类中,继承该类,让该类成为他们的父类.d22
class CollectionPrettyCell: CollectionViewBaseCell {

    //控件属性
    @IBOutlet weak var cityBtn: UIButton!
    
    //MARK: - 定义模型属性.d22
    //存储属性监听
    override var anchor: AnchorModel? {
        
        didSet {
           //将属性传递给父类.d22
            super.anchor = anchor
            //城市
            cityBtn.setTitle(anchor?.anchor_City, for: .normal)
            
        }
    }
     
}
