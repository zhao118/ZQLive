//
//  BaseGameModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/3.
//

import Foundation

//创建一个父类模型,在里面添加一些其他模型也会用到的共有的属性(名称一样的属性).前提是用class创建模型,struct不能被继承
//再创建其他模型的时候,可以直接继承该父类模型,也就继承了父模型的属性,再在子类中添加自己独有的属性.与子类继承父类一样的原理.d71

class BaseGameModel: NSObject {
    //组显示的标题
    var tag_name: String = ""
    var pic_url: String = ""
    
    //自定义构造函数,便于创建该模型.d21
    override init() {
        
    }
    //构造函数
    init(dic: [String: Any]) {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

