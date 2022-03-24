//
//  CollectionViewBaseCell.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/17.
//

import UIKit

//CollectionPrettyCell与CollectionNormallCell中相同的地方都写在该类中,继承该类,让该类成为他们的父类.d22
class CollectionViewBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    //属性检查器中取消了button的交互功能(取消User interaction Enable).d22
    @IBOutlet weak var onlineBtn: UIButton!
    @IBOutlet weak var nickName: UILabel!
    
    //MARK: - 定义模型属性.d22
    //存储属性监听
    var anchor: AnchorModel? {
        didSet {
            guard let anchor = anchor else { return }
            
            //取出在线人数显示的文字
            var onlineStr = ""
            if anchor.online >= 10000 {
                onlineStr = "\(anchor.online / 10000)万人在线"
                
            }else{
                onlineStr = "\(anchor.online)人在线"
            }
            
            onlineBtn.setTitle(onlineStr, for: .normal)
            
            //昵称
            nickName.text = anchor.nickname
           
            //封面图片.显示网络图片最好使用第三方框架(如Kingfisher).d22
            //注意这里是URL不是NSURL类型
            guard let iconURL = URL(string: anchor.vertical_src) else { return }
        
            iconImageView.kf.setImage(with: iconURL)
            
        }
    }
    
}
