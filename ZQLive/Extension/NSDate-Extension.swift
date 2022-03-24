//
//  NSDate-Extension.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/15.
//

import UIKit

extension NSDate {
    //扩展NSDate的一个类方法,从1970到当前的时间总共是多少秒.d20
    class func getCurrentTIme() -> String {
        //当前时间
        let nowDate = NSDate()
        //系统的时候是从1970开始,从1970到当前时间一共有多少秒
        let interval = nowDate.timeIntervalSince1970
        //强转为int类型,可以去掉后面的小数点
        let intervalInt = Int(interval)
        
        return String(intervalInt)
    }
}
