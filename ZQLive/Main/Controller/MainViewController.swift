//
//  MainViewController.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/8.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildVC(storyboardName: "Home")
        addChildVC(storyboardName: "Live")
        addChildVC(storyboardName: "Follow")
        addChildVC(storyboardName: "Profile")
        
    }

    private func addChildVC(storyboardName: String) {
        
        //为了适配ios8(ios8不能在Mian.storyboard中连接子控制器并通过Editor-Refactor to storyboard分离SB文件)需要在代码中将SB中创建的视图控制器添加进UITabBarController中.d6
        //1.通过SB获取控制器(即获取SB中创建的视图控制器,再将其加入到UITabBarController中,达到UITabBarController连接子视图控制器的效果,并实现Editor-Refactor to storyboard分离SB文件)
        let childVC = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()!
        
        //2.将childVC作为子控制器
        addChild(childVC)
    }
}
