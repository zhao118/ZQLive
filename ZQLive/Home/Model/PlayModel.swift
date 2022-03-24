//
//  PlayModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/8.
//

import Foundation


//娱乐轮播器模型
struct PlayCycleModel: Codable {
    
    var tag_name: String?
    //roo_list里面有四个对象
    var room_list: [PlayCycleRoomListModel]
    
}

struct PlayCycleRoomListModel: Codable {
    
    var room_src: String?
}


//娱乐collectionView模型
struct PlayModel: Codable {
    
    var tag_name: String?
    //roo_list里面有四个对象
    //控制台提示:将数组类型的JSON数据解码为字典,所以这里也需要是数组对象
    var room_list: [PlayRoomListModel]

    
}

struct PlayRoomListModel: Codable {
    
    var room_src: String?
}
