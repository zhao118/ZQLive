//
//  jsonToModelFunc.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/27.
//

import Foundation


//扩展类方法-将JSON数据转换为模型对象
extension RecommendViewModel{
    
   class func jsonToModel() ->DataModel{
        
        var groupModel = DataModel()
    
        if let struJsonURL = Bundle.main.url(forResource: "json2", withExtension: "json"){
            if let struData = try? Data(contentsOf: struJsonURL){
                let decoder = JSONDecoder()
                //下划线转小驼峰格式
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do{
                    groupModel = try decoder.decode(DataModel.self, from: struData)
                    
                    
                    //                print("groupModel.tagName的值为: \(groupModel.tagName)")
                    //                print(groupModel.roomList[0].nickName)
                    
                }catch{
                    print("解析失败: \(error)")
                }
                
            }
        }
        return groupModel
    }
}

