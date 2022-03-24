//
//  FunnyVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/10.
//

import UIKit


//继承一个父类(该处是PlayVC),就可以使用父类中的设置.d81
//viewDidLoad()方法不用写,因为父类中含有,如果该类中想自定义该方法,可以override覆写
class FunnyVC: PlayVC{

    private let kTopMargin: CGFloat = 20
    

}


extension FunnyVC {
    //父类中有setupUI()方法,此处要重写就需要使用override
    //该处重写父类的setupUI(),因为需要去掉父类中的HeaderView
    //覆写时,需要super.setupUI(),调用父类中的setupUI(),因为还需要使用父类中的setupUI()中的方法
    //比如添加collectionView
    override func setupUI() {
        
        super.setupUI()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.headerReferenceSize = .zero
        
        //重置内边距contentInset.同时取消掉轮播器
        collectionView.contentInset = UIEdgeInsets(top: kTopMargin, left: 0, bottom: 0, right: 0)
        playCycleView.frame = .zero
        
        collectionView.delegate = self
        
    }

}

//可以在子类中重新实现一些方法,从而优化父类中的一些方法,让其符合子类的要求.d77
//可以直接增加一些方法,也可以override覆写父类中的方法.
extension FunnyVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: kPlayItemW, height: KPlayNormalItemH)
    }
    
}
