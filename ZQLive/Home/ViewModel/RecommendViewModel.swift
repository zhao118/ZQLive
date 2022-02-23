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
    lazy var anchorGroups: [AnchorGroup] = [] //主播主
    //在AnchorGroup中再添加一个构造函数,便于在这里直接以AnchorGroup()的形式创建一个AnchorGroup对象.d21
    private lazy var bigDatagroup = AnchorGroup()
    private lazy var prettyDatagroup = AnchorGroup()
    
    
}

//MARK: - 网络请求
//MVVM5.5使用封装的Alamofire工具类
extension RecommendViewModel {
    
    //e3.1逃逸闭包参数,用于当请求完成时,提醒已经请求完成,完成之后的一个回调函数(reloadData).d21
    //逃逸闭包常用于异步操作中,如一个后台请求完成后要执行闭包回调
    func requestData(finishedCallback: @escaping () -> ()) {
        
        //0.定义参数
        let parameters = ["limit":"4","offset": "0","time": NSDate.getCurrentTIme()]
        //d8.1创建调度组,让异步执行的网络请求顺序执行,按顺序来到需要的数据,即按推荐,颜值,游戏的顺序得到数据.d21
        let disGroup = DispatchGroup()
        
        //1.请求第一部分推荐数据
        //http://capi.douyucdn.cn/api/v1/getbigDataRoom?time=1645008826
        disGroup.enter() //d8.2进入组.d21
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrentTIme()]) { (result) in
            
            guard let resultDic = result as? [String: NSObject] else { return }
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else { return }
           
            self.bigDatagroup.tag_name = "热门"
            self.bigDatagroup.icon_name = "morentupian"
            
            //获取主播数据
            for dic in dataArray {
                let anchor = AnchorModel(dict: dic)
                self.bigDatagroup.anchors.append(anchor)
        
            }
            
            disGroup.leave() //d8.3离开调度组
            print("请求到第一组数据")
            
        }
        
        //2.请求第二部分颜值数据.d21
        disGroup.enter() //d8.4
        NetworkTools.requestData(type: .GET, USLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
          
            guard let resultDic = result as? [String: NSObject] else { return }
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else { return }
            
           
         
            self.prettyDatagroup.tag_name = "颜值"
            self.prettyDatagroup.icon_name = "morentupian"
            
            //获取主播数据.d21
            for dic in dataArray {
                let anchor = AnchorModel(dict: dic)
                self.prettyDatagroup.anchors.append(anchor)
            }
          
            disGroup.leave() //d8.5
            print("请求到第二组数据")
            
        }
        
        //3.请求后面部分游戏数据
        //后端接口文档的示例.该处根据文档来使用一些实参.d20
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
           // print("dataArray: \(dataArray)") //可以打印出数组信息
            
            //3.遍历数组,获取字典,并且将字典转换为模型对象(字典一般是转换为模型),使用KVC来转换.d20
            //KVC:KVC（Key-value coding)键值编码,可通过Key名直接访问对象的属性，或者给对象的属性赋值.可以用三方框架来转
            for dict in dataArray {
                
                let group = AnchorGroup(dict: dict)
                //print("group: \(group)") //只能打印一个内存地址
                self.anchorGroups.append(group) //将请求到的所有组数据放到模型对象中

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
            
            //e3.2当所有的网络请求已经完成,拿到数据之后对外面的一个回调,即执行一个回调函数reloadData.d21
            finishedCallback()
        }
    }
}
