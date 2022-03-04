//
//  Model.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/28.
//

import Foundation

//class CycleModel2: Codable{
//
//    var title: String = ""
//    var pic_url: String = ""
//    //主播信息对应的字典
//   //var room: AnchorModel2?
//
//}
//
//class AnchorModel2: Codable {
//    //房间号
//    var room_id: Int?
//    //房间图片
//    var vertical_src: String = ""
//    //判断是手机直播还是电脑直播.0:电脑直播; 1:手机直播
//    var isVertical: Int = 0
//    //房间名称
//    var room_name: String = ""
//    //主播昵称
//    var nickname = ""
//    //观看人数
//    var online = 0
//    //所在的城市.请求的数据中没有城市的信息.d21
//    var anchor_City = ""
//
//}

//分组中的数据模型(将字典类型转换为模型对象).d20
struct AnchorGroup2: Codable{

    //组显示的标题
    var tag_name: String = ""
    //组显示的图标,设置一个默认图标,每一个分组左上角的小图标
    var icon_name : String?
    
    var room_list: AnchorModel2
    
   
    
}

//分组中的每个主播房间的模型对象(填充每个cell的数据模型)
struct AnchorModel2: Codable {
    //房间号
    //var room_id: Int?
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
    var anchor_City: String?
    
    //游戏对应的小图标.数据转模型,该图标得到的是一个URL.d28
    var game_icon_url: String?
    
    var room_src: String?
}

//轮播器模型对象
//Codable-1.创建一个结构体类型的模型对象,实例化模型对象的方法,且该对象继承的是Codable
struct CycleModel2: Codable{

    var title: String?
    var pic_url: String?
    
   
    //主播信息对应的字典.JSON数据中room的值是一个对象,对象里面是字典(名称值对)
   var room: AnchorModel2?
    
}
