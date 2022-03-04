//
//  AnchorModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/16.
//

import UIKit

//以NSObject为基类，只是为了提供Objective-C API的使用入口
//room_list的值是一个字典,就该字典再创建一个模型对象. 一个主播房间里的信息模数据型.d20
class AnchorModel: NSObject {
    //房间号
    var room_id: Int = 0
    //房间图片
    var vertical_src: String = ""
    //判断是手机直播还是电脑直播.0:电脑直播; 1:手机直播
    var isVertical: Int = 0
    //房间名称
    var room_name: String = ""
    //主播昵称
    var nickname = ""
    //观看人数
    var online = 0
    //所在的城市.请求的数据中没有城市的信息.d21
    var anchor_City = ""
    init(dict: [String: NSObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    

}
