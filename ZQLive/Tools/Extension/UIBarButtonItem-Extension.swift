//
//  UIBarButtonItem-Extension.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/8.
//

import UIKit

//扩展一个UIBarButtonItem的类方法(class标记为类方法)
//类方法使用class或static修饰,class修饰的类方法可以使用override覆写
extension UIBarButtonItem {
    //该实例化方法可以实现点击颜色变灰的效果
    class func creatItem(imageName: String, highImageName: String = "", size:CGSize = CGSize.zero) ->UIBarButtonItem {
        
        //创建button
        let btn = UIButton() 
        //设置button的图片
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
            
        }
        //设置button的尺寸
        if size == CGSize.zero {
            //因为没有设置button的frame就无法显示button,所以设置为自适应图片的大小来作为button的frame
            btn.sizeToFit()
            
        }else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        //穿件UIBarButtonItem
        let btnItem = UIBarButtonItem(customView: btn)
        
        return btnItem
        
    }
}
