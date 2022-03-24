//
//  BaseVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/12.
//

import UIKit

class BaseVC: UIViewController {
    
    //.d83
    var contentView: UIView?
    
    lazy var animalImageView: UIImageView = {
       //使用图片制作加载动画.d83
        let animalImageView = UIImageView(image: UIImage(named: "load1"))
        animalImageView.center = self.view.center
        animalImageView.animationImages = [UIImage(named: "load1")!,UIImage(named: "load2")!,UIImage(named: "load3")!]
        animalImageView.animationDuration = 0.5
        animalImageView.animationRepeatCount = LONG_MAX
        
    
        //让控件随着父视图的顶部和底部的拉伸而拉伸,让animalImageView控件展示在屏幕上居中.d83
        //因为遵守当前类的子类控制器中的collectionView的frame是有被压缩或拉伸一部分的,故需要此步骤
        animalImageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        
        return animalImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

       setupUI()
    }
    

}

extension BaseVC {
    
   @objc func setupUI() {
        
        //1.先隐藏内容View,即子类的collectionView.d83
        contentView?.isHidden = true
        //2.添加动画imageView
        view.addSubview(animalImageView)
        //3.执行animalImageView的动画
        animalImageView.startAnimating()
        
    }
    
    //当网络数据请求完成时调用.d83
    func loadDataFinished() {
        //停止动画
        animalImageView.stopAnimating()
        //隐藏animalImageView
        
        animalImageView.isHidden = true
        
        //显示内容view(collectionView)
        contentView?.isHidden = false
    }
}
