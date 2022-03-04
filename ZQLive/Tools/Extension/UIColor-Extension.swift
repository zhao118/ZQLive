//
//  UIColor-Extension.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/9.
//

import UIKit

//自定义构造函数来扩展UIColor(扩展为将传入的实参默认除以255.0).d10
extension UIColor {
    
    //此处自定义构造函数需定义为便利构造函数(构造函数分指定构造函数和便利构造函数,默认的为指定构造函数)
    convenience init(r: CGFloat, g: CGFloat, b:CGFloat) {
        
        //还需要用self调用init(),这里扩展了将传入的实参除以255.0
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    
    }
    
    //扩展UIColor一个获取随机颜色的方法.d70
    class func randomColor()-> UIColor {
        
      return  UIColor(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
        
    }
}
