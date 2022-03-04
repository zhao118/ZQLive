//
//  RecommendViewModel.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/14.
//

import UIKit

//MVVM5.1RecommendView视图控制的ViewModel部分.MVVM中的VM部分.d19
//viewModel适合放置用户输入验证逻辑,视图显示逻辑,发起网络请求等.MVC模式这一块是放置控制器中的,会造成臃肿,不便维护.
class RecommendViewModel {
    
    //MARK: - 懒加载属性
    lazy var anchorGroups: [AnchorGroup] = [] //接受主播主
    lazy var cycleModels: [CycleModel] = [] //接受轮播模型数据
    
    lazy var anchorGroups2: [AnchorGroup2] = [ ]
    lazy var cycleModels2: [CycleModel2] = [ ]
   
    
    //在AnchorGroup中再添加一个构造函数,便于在这里直接以AnchorGroup()的形式创建一个AnchorGroup对象.d21
    private lazy var bigDatagroup = AnchorGroup()
    private lazy var prettyDatagroup = AnchorGroup()
    
    lazy var anchorPrettyAnchorModel2: [AnchorModel2] = [ ] //接受颜值数据模型
    lazy var bigDatagroup2 : [AnchorModel2] = [ ]
    

}

//MARK: - 网络请求
//MVVM5.5使用封装的Alamofire工具类
extension RecommendViewModel {
    
    //一大类.请求推荐部分数据
    //e3.1逃逸闭包参数,用于当请求完成时,提醒已经请求完成,完成之后的一个回调函数(reloadData).d21
    //逃逸闭包常用于异步操作中,如一个后台请求完成后要执行闭包回调
    //闭包参数是为了当请求到数据的时候,告诉外面已经请求到了,即可以使用该数据了
    func requestData(finishedCallback: @escaping () -> ()) {
        
        //0.定义参数
        let parameters = ["limit":"4","offset": "0","time": NSDate.getCurrentTIme()]
        //d8.1创建调度组,让异步执行的网络请求顺序执行,按顺序来到需要的数据,即按推荐,颜值,游戏的顺序得到数据.d21
        let disGroup = DispatchGroup()
        
        //1.请求第0部分推荐数据
        //根据公司提供的后端接口文档来传入一些实参.d20
        //url拼接好参数后的完整网址: http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1645008826
        //d8.2进入组.d21
        disGroup.enter()
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrentTIme()]) { (result) in
            
            //result as? [String: NSObject]可以改为result as? [String: Any]
            guard let resultDic = result as? [String: NSObject] else { return }
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else { return }
           
            self.bigDatagroup.tag_name = "热门"
            self.bigDatagroup.icon_name = "littleIcon"
            
            //获取主播数据 //字典转模型.room_list里的数据转model.d21
            for dic in dataArray {
                let anchor = AnchorModel(dict: dic)
                self.bigDatagroup.anchors.append(anchor)
                
//                do{
//                    let data2 = try JSONSerialization.data(withJSONObject: dic)
//                    let groupModel2 = try JSONDecoder().decode(AnchorModel2.self, from: data2)
//                    self.bigDatagroup2.append(groupModel2)
//
//
//                }catch let error{
//                    print(error)
//                }
        
            }
            
            disGroup.leave() //d8.3离开调度组
            print("请求到第一组数据")
            
        }
        
        //2.请求第1部分颜值数据.d21
        disGroup.enter() //d8.4
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
          
            guard let resultDic = result as? [String: NSObject] else { return }
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else { return }
     
            self.prettyDatagroup.tag_name = "颜值"
            self.prettyDatagroup.icon_name = "morentupian"
            
            //字典转模型.room_list里的数据转model.d21
            for dic in dataArray {
                let anchor = AnchorModel(dict: dic)
                self.prettyDatagroup.anchors.append(anchor)
                
//                do{
//                    let data2 = try JSONSerialization.data(withJSONObject: dic)
//                    let groupModel2 = try JSONDecoder().decode(AnchorModel2.self, from: data2)
//                    self.anchorPrettyAnchorModel2.append(groupModel2)
//
//
//                }catch let error{
//                    print(error)
//                }

            }
          
            disGroup.leave() //d8.5
            print("请求到第二组数据")
            
        }
        
        //3.请求后面2-12组部分游戏数据
        //根据公司提供的后端接口文档来传入一些实参.d20
        //parmeters中的limit:请求数据的个数,每区共4个cell,所以设为4;offset:请求数据的偏移量(即从第几个数据开始请求,0不偏移,从第一个开始);time:从当前时间开始(以秒为单位)获取,才能从服务器获取最新的数据.
        //这些参数的作用是通过分析斗鱼项目得出的??
        
        //将参数拼接在URL中,time后面为print(NSDate.getCurrentTIme())打印出来的系统的当前时间.d20
        //将拼接好的网址在浏览器中打开,然后得到JSON数据,再把JSON数据放入到JSON解析网站中,选择JSON在线编辑,进行解析(www.kjson.com)
        //"http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1644915928"
        //print(NSDate.getCurrentTIme())
        
        disGroup.enter() //d8.6
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (reslt) in
            //1.将result转成字典类型
            guard let resultDic = reslt as? [String: NSObject] else { return }
            //2.根据data该key,获取数组
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else { return }
            //3.遍历数组,获取字典,并且将字典转换为模型对象(字典一般是转换为模型).d20
            
            for dic in dataArray {
                let group = AnchorGroup(dic: dic)
                self.anchorGroups.append(group) //将请求到的所有组数据放到模型对象中
                
//                do{
//                    let data2 = try JSONSerialization.data(withJSONObject: dic)
//                    let groupModel2 = try JSONDecoder().decode(AnchorGroup2.self, from: data2)
//                    self.anchorGroups2.append(groupModel2)
//
//                }catch let error{
//                    print(error)
//                }
//
            }
            //d8.7请求到2-12组数据
            disGroup.leave()
            print("请求到第三组数据")

}
        
        //d8.8使用调度组disGroup让异步网络请求按顺序执行,再用notify(:,:)保证请求到所有的数据之后再执行.d21
        disGroup.notify(queue: .main) {
            print("请求到所有的数据")
            self.anchorGroups.insert(self.prettyDatagroup, at: 0)
            self.anchorGroups.insert(self.bigDatagroup, at: 0) //最终bigDatagroup是第0个元素
            
            //e3.2当所有的网络请求已经完成时，执行该闭包,即可以执行一个方法（回调函数reloadData）.d21
            finishedCallback()
        }
    }
    
    //二大类.请求无线轮播的数据.d24
    func requestCycleData(finishedCallback: @escaping () -> ()) {
        //闭包参数是为了当请求到数据的时候,告诉外面已经请求到了,即可以使用该数据了.d24
        //拼接方式:http://www.douyutv.com/api/v1/slide/6?version=2.300
        NetworkTools.requestData(type: .GET, USLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version": "2.300"]) { (result) in
            //获取整体的字典数据
            guard let resultDict = result as? [String: NSObject] else { return }
            //根据字典的key获取数据
            guard let dataArray = resultDict["data"] as? [[String: NSObject]] else { return }
            //字典转模型对象(一般是将字典转换为模型,数组也是可以的,使用Codable的编码)
            for dic in dataArray {
                //用请求到的JSON数据创建模型对象,并保存到数组中(字典转模型)
                //必须要都这里的do try catch 来处理可能抛出的错误
                do{
                    let data2 = try JSONSerialization.data(withJSONObject: dic)
                    //虽然请求到的JSON数据的data键对应的值数据是一个数组,但是这里进行了数据的遍历,每一个数组元素是字典
                    //所以这里转成的模型对象也是一个字典,而不是数组,所以不需要使用[CycleModel2].self
                    let model2 = try JSONDecoder().decode(CycleModel2.self, from: data2)
                    self.cycleModels2.append(model2)
                    
                }catch let error{
                    print(error)
                }
   
            }
            //有六个数组,说明这里请求数据是成功的,在JSON数据转模型的时候失败.
            print("dic的个数为:\(self.cycleModels.count)")
            
            //这里调用闭包，意思是在请求完成后（print(result)后）可以执行一个闭包，即可以执行一个方法
            //所以在调用该方法requestCycleData时,可以在最后调用一个方法
            //因为是在另外一个方法requestData的闭包中使用了方法requestCycleData的闭包参数,所以需要将方法requestCycleData的闭包逃逸
            finishedCallback()
        }
        
    }
}

//extension RecommendViewModel {
//
//    func JSONToModel(dic:[String: NSObject]) {
//
//        //用请求到的JSON数据创建模型对象,并保存到数组中(字典转模型)
//        do{
//            let data2 = try JSONSerialization.data(withJSONObject: dic)
//            //虽然请求到的JSON数据的data键对应的值数据是一个数组,但是这里进行了数据的遍历,每一个数组元素是字典
//            //所以这里转成的模型对象也是一个字典,而不是数组,所以不需要使用[CycleModel2].self
//            let model2 = try JSONDecoder().decode(CycleModel2.self, from: data2)
//
//            self.cycleModels2.append(model2)
//
//        }catch let error{
//            print(error)
//        }
//    }
//}
