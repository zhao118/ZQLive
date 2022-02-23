//
//  NetworkTools.swift
//  LittlePinkApp
//
//  Created by ZhaoQ on 2022/2/14.
//  Copyright © 2022 ZhaoQ. All rights reserved.
//

import UIKit
import Alamofire

//工具类的封装-封装Alamofire网络请求框架到工具类中,若以后该框架不再更新出现的无法使用时,只需到工具类中修改替换.d18
//也可以封装为结构体

//请求方式
enum MethodType {
    case GET
    case POST
}

class NetworkTools {
    
    //封装为类方法.http请求需在info.plist中配置项,默认是HTTPS请求
    //parameters:请求参数;finishedCallback:请求完成时候的回调函数,闭包类型,里面有请求到的数据.d18
    //finishedCallback:参数需要使用逃逸闭包
    //教程中是parameters: [String: NSString]? = nil
    class func requestData(type: MethodType, USLString: String, parameters: [String: String]? = nil, finishedCallback: @escaping (_ result : Any) -> ()) {
        
        //1.获取类型
        let method = type == MethodType.GET ? HTTPMethod.get : HTTPMethod.post
        
        //2.发送网络请求
        AF.request(USLString, method: method, parameters: parameters).responseJSON{ (response) in
            
            //3.获取结果
            guard let result = response.value else {
                print(response.error!)
                return
            }
            
            //4.将结果回调出去
            finishedCallback(result)
        }
    
    }
}


