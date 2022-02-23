//
//  AnchorGroup.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/15.
//

import UIKit

//主播分组中的数据模型(将字典类型转换为模型对象).d20
class AnchorGroup: NSObject {
    //根据请求到的斗鱼的JSON数据中的属性名称来定义.d20
    //该组中对应的房间信息
    //将room_list转为模型对象,方法二:
    //使用存储属性的监听
    var room_list: [[String: NSObject]]? {
        didSet {
            guard let room_list = room_list else { return }
            
            for dict in room_list {
                anchors.append(AnchorModel(dict: dict))
            }
        }
        
    }
    //组显示的标题
    var tag_name: String = ""
    //组显示的图标,设置一个默认图标
    var icon_name = "morentubiao"
    
    //定义主播的模型对象数组.d20
     lazy var anchors: [AnchorModel] = []
    
    //MARK: - 构造函数
    //再覆写父类的构造函数,便于直接以AnchorGroup()的形式创建AnchorGroup对象.d21
    override init() { }
   
    //构造方法
    init(dict: [String: NSObject]) {
        super.init()
        
        //KVC方法使用给定字典中的值设置为当前类的属性的值，并使用其键来标识属性名称。
        //setValuesForKeys(dict)
        setValuesForKeys(dict)
    }

    //因为请求到的数据中,主播分组中的字典部分,还有写属性并没有在该处定义对应的属性,可能会报错,故重写该方法.d20
    //当找不到给定键的属性时,调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    
    /*
    将room_list转为模型对象,方法一:
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "room_list" {
            if let dataArray = value as? [[String: NSObject]] {
                for dict in dataArray {
                    anchors.append(AnchorModel(dict: dict))
                }
            }
        }
    }
 */
  
    
    
}
