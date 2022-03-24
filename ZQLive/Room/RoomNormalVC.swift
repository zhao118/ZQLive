//
//  RoomNormalVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/14.
//

import UIKit

class RoomNormalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
        self.view.backgroundColor = .red
    }
    
    //
    override func viewWillAppear(_ animated: Bool) {
        //当view将要出现时,隐藏掉下面的tabBar和上面的导航栏.d85
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
        //隐藏导航栏
        //navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        
        //当隐藏掉导航栏(导航栏中自带返回按钮)时,同时会取消右滑返回上一级的手势,故这里需要加上此手势.d85
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    

}
