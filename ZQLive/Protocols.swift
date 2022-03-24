//
//  Protocols.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/10.
//

import UIKit

//使用协议进行传值.从PageContentView传到HomeViewController中给PageTitleView使用x1.d12
//继承class:只允许类继承该协议
protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}
