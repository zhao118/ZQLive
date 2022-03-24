//
//  UIView-Extension.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/12.
//

import UIKit

extension UIView {
    //在SB属性检查器中增加属性.也可以使用关键字实时显示，但是比较耗资源，
    @IBInspectable
    //计算属性
    //注意在扩展系统类时，给里面的属性命名是不要与包中的扩展的属性同名
    //添加成功之后在属性检查器中会展示，首字母大写。每个view都会增加一个radius属性
    var radius: CGFloat{
        get{
            //返回(得到)radius的值
            return layer.cornerRadius
        }
        set{
            //增加一个Clips to Bounds避免每次都需要在SB中勾选.x22
            clipsToBounds = true
            //newValue代表cornerRadius的值，
            //这里表示在SB检查器中输入的值(radius),将值传给newValue
            self.layer.cornerRadius = newValue
        }
        
    }
}
