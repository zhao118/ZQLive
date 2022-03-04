//
//  jsonToModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/27.
//

import Foundation

//自己重新使用json2中数据定义的model替换AnchorGroup-主播分组中的数据模型
struct DataModel: Codable{
    //改组中对应的房间信息,即四个cell中的数据
    //roomList的值是一个数组,定义模型时,只需定义数组中的一个元素对应的属性
    var roomList: [DataRoomListModel] = [ ]
    var tagName = ""
    //该属性JSON数据中没有,需直接赋初始值
    //var iconName = "morentupian"
    //定义主播的模型对象数组.d20
     lazy var anchors: [DataRoomListModel] = []
    
}

//替换AnchorModel
struct DataRoomListModel: Codable {
    //定义roomList模型,只需定义roomList数组中的一个元素对应的属性
    //
    var roomId = 0 //房间号
    //var verticalSrc = "" //房间图片
    var verticalSrc = ""
    var isVertical = 0 //0:电脑直播;1:手机直播
    var roomName = "" //房间名称
    var nickName = "" //主播名称
    var online = 0 //在线人数
    var avatarSmall = "" //小图片
   
}
