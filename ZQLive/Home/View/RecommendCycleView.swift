//
//  RecommendCycleView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/18.
//

import UIKit

//推荐页上面的无线轮播器的制作.d23
class RecommendCycleView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        //从xib中开始加载时就执行.d23
        //设置该控件不随着父控件的拉伸而拉伸
     autoresizingMask = AutoresizingMask(rawValue: .zero)
        
    }
    
}

//MARK: - 提供一个快速创建view的类方法.d23
extension RecommendCycleView {
    
    class func recommendCycleView() -> RecommendCycleView {
        let recommendCycleView = Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as!
            RecommendCycleView
        
        
        //使用xib快速创建类(RecommendCycleView对象)的方法
        return recommendCycleView
    }
    
}
