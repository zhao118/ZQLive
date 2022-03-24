//
//  PlayViewModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/7.
//

import Foundation

class PlayViewModel{
    
    
    var playCycleModels: [PlayCycleModel] = [ ]
    
    var playModels: [PlayModel] = [ ]
    
    
    let parameters = ["limit":"4","offset": "0","time": NSDate.getCurrentTIme()]
}

extension PlayViewModel {
    
    //娱乐界面的数据,包含轮播器和下面collectionView的数据
    //loadPlayData中的闭包需要在requestData的闭包中使用,所以需要逃逸
    func loadPlayData(finishedCallBack: @escaping () -> ()){
        
        //"http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1644915928"
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { [self] (result) in
            
            guard let resultDic = result as? [String: Any] else { return }
            
            guard let dataArray = resultDic["data"] as? [[String: Any]] else { return }
            
            for dic in dataArray {
                
                do{
                    
                    let decoder = JSONDecoder()
                   
                    
                    let data = try JSONSerialization.data(withJSONObject: dic)
                    
                    let model = try decoder.decode(PlayCycleModel.self, from: data)
                    
                    let model2 = try decoder.decode(PlayModel.self, from: data)
                    
                    self.playCycleModels.append(model)
                    self.playModels.append(model2)
                    
                    print("playCycleModels.count 个数为: \(playCycleModels.count)")
                    print(playModels.count)
                    print(model.tag_name)
                    
                }catch let error{
                    
                    print(error)
                }
            }
            
            finishedCallBack()
            
        }
        
      
        
    }
    
}
