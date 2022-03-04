//
//  AnchorGroup.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/15.
//

import UIKit

//创建一个父类模型,在里面添加一些其他模型也会用到的共有的属性(名称一样的属性).前提是用class创建模型,struct不能被继承
//再创建其他模型的时候,可以直接继承该父类模型,也就继承了父模型的属性,再在子类中添加自己独有的属性.与子类继承父类一样的原理.d71
//主播分组中的数据模型(将字典类型转换为模型对象).d20
class AnchorGroup: BaseGameModel {
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
    
    
    //组显示的图标,设置一个默认图标
    var icon_name = "morentubiao"
    
    //定义主播的模型对象数组.d20
    lazy var anchors: [AnchorModel] = []
    
    
    //该部分全部继承自父类模型,该处可以省去.d71
    //组显示的标题.
    //var tag_name: String = ""
    
    //    //MARK: - 构造函数
    //    //再覆写父类的构造函数,便于直接以AnchorGroup()的形式创建AnchorGroup对象.d21
    //    override init() { }
    //
    //    //构造方法
    //    init(dict: [String: NSObject]) {
    //        super.init()
    //
    //        //KVC方法使用给定字典中的值设置为当前类的属性的值，并使用其键来标识属性名称。
    //
    //        setValuesForKeys(dict)
    //    }
    //
    //    //因为请求到的数据中,主播分组中的字典部分,还有些属性并没有在该处定义对应的属性,可能会报错,故重写该方法.d20
    //    //当找不到给定键的属性时,调用
    //    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
    //
    

}
