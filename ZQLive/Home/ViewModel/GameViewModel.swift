//
//  GameViewModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/3.
//

import UIKit

//MVVM中的VM部分,即ViewModel部分
class GameViewModel {
    
    //因为使用的是轮播器中的URL，所以模型也是使用的轮播器的模型，故可以替换为轮播器的模型
    //lazy var gameModels2 : [GameModel2] = [ ]
    
    lazy var gameModels2 : [CycleModel2] = [ ]
    
    
}

//请求游戏部分的数据,并抓换为模型.d71
extension GameViewModel {
   
    func laodaAllGameData(finishedCallback: @escaping () ->()) {
        //根据公司提供的后端接口文档来传入一些实参.d71
        //拼接好参数的URL: http://capi.douyucdn.cn/api/v1/getColumnDetail?shortName=game
        //这里使用轮播器中的URL,上面的URL请求数据失败
        NetworkTools.requestData(type: .GET, USLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version": "2.300"]) { (result) in
            //1.获取数据.需要的数据在"data"所对应的值中
            guard let resultDic = result as? [String : Any] else { return }
            guard let dataArray = resultDic["data"] as? [[String : Any]]else { return }
            
            //2.字典转模型
            for dic in dataArray {
                
                do {
                    let data2 = try JSONSerialization.data(withJSONObject: dic)
                    //虽然请求到的JSON数据的data键对应的值数据是一个数组,但是这里进行了数据的遍历,每一个数组元素是字典
                    //所以这里转成的模型对象也是一个字典,而不是数组,所以不需要使用[CycleModel2].self
                    let model2 = try JSONDecoder().decode(CycleModel2.self, from: data2)
                    self.gameModels2.append(model2)
                    
                }catch  let error{
                    
                    print(error)
                    
                }
            }
            
            //3.完成回调
            finishedCallback()
            
        }
        
    }
}
