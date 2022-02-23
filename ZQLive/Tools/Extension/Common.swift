//
//  Common.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/9.
//

import UIKit


//屏幕尺寸.屏幕宽和高
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kTabBarH:CGFloat = 44 //下方工具栏的高度

//使用闭包创建属性.动态获取状态栏的高度(因为状态栏的高度不一样,需动态获取)
let kStatusBarH: CGFloat = {
    
    var statusBarHeight: CGFloat = 0
    
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
         statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
    } else {
         statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    
    return statusBarHeight
    
}()

