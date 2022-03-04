//
//  CycleModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/28.
//

import UIKit

//以NSObject为基类，只是为了提供Objective-C API的使用入口
//轮播的数据模型.d24
class CycleModel: NSObject {

    var title: String = ""
    var pic_url: String = ""
    //主播信息对应的字典
    var room: [String: NSObject]? {
        didSet{
            guard let room = room else { return }

            anchor = AnchorModel(dict: room)
        }
    }

    //主播信息对应的模型对象
    var anchor: AnchorModel?

    //自定义构造函数
    init(dic: [String: Any]) {
        super.init()

        setValuesForKeys(dic)

    }
    //调用该方法,避免没有转换完JSON数据中的属性而报错.d24
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}

