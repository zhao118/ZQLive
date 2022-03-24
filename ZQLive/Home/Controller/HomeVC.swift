//
//  HomeViewController.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/8.
//

import UIKit

//private:同一类中私有 fileprivate:同一文件(项目)中私有
private let kTitleViewH: CGFloat = 60 //标签栏的Title的高度

class HomeVC: UIViewController {
    
    //MARK: - 懒加载属性
    //使用闭包创建对象(分页栏对象)
    private lazy var pageTitleView: PageTitleView = {[weak self] in //解决闭包中使用self强引用造成循环引用
        
        //CGRect()构造包含原点位置和尺寸的矩形对象
        //导航栏高度
        let kNavigationH = CGFloat((self?.navigationController?.navigationBar.frame.height)!)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleFrame = CGRect(x: 0, y: kNavigationH + kStatusBarH, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
      
        titleView.delegate = self //设置代理为当前类-p4.d11
        return titleView
        
    }()
    
    //创建分页栏每一项具体的内容视图view.(每一项分页里面包含一个cell,每个cell都有一个子视图控制器)
    private lazy var pageContentView: PageContentView = { [weak self] in //3.1解决闭中使用self包引起的循环强引用.d11
        //1.内容视图的frame
        //3.2self为可选类型:解决闭中使用self包引起的循环强引用.d11
        let kNavigationH = CGFloat((self!.navigationController?.navigationBar.frame.height)!)  //导航栏高度
        let contentH = kScreenH - kNavigationH - kStatusBarH - kTitleViewH - kTabBarH //减去kTabBarH,避免里面的item最下方显示不全.d14
        let contentFrame = CGRect(x: 0, y:kNavigationH + kStatusBarH + kTitleViewH, width: kScreenW, height: contentH )
        //2.内容视图的子视图
        var childVCs:[UIViewController] = []
        
        childVCs.append(RecommendVC()) //添加"推荐"子控制器.d14
        childVCs.append(PlayVC()) //添加娱乐控制器
        childVCs.append(GameVC()) //添加"游戏"子控制器.d70
        childVCs.append(FunnyVC())//趣玩.d
        
        let pageContentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentViewController: self)
        
        pageContentView.delegate = self //协议传值x4
        
        return pageContentView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //避免返回时，主页上面的导航栏的图标消失
        self.navigationController?.navigationBar.isHidden = false
      
        
    }
    
}

//MARK: - 设置UI界面
extension HomeVC {
    
    //设置UI
    private func setupUI() {
        //0.不需要调整UIScrollView的内边距,默认当有导航栏的时候在加UIScrollView时会调整内边距,不设置也可正常显示titles.d9
        //automaticallyAdjustsScrollViewInsets = false
        
        //1.设置导航栏
        setupNavigationBar()
        
        //2.添加TitleView
        self.view.addSubview(pageTitleView)
        
        //3.添加PageContentView(里面包含一个ScrollView,ScrollView有四个视图控制器,推荐,游戏,娱乐,趣玩)
        self.view.addSubview(pageContentView)
       
    }
    
    //设置导航栏UI.d7
    private func setupNavigationBar() {
        //导航栏左侧图标
        navigationItem.leftBarButtonItem = UIBarButtonItem.creatItem(imageName: "douyu-3")
        
        //右侧添加多个item,分别设置正常状态和点击高亮状态时的图片.大小为40x40.d7
        let size = CGSize(width: 40, height: 40)
        //扩展UIBarButtonItem的类方法creatItem.d7
        //let historyItem = UIBarButtonItem.creatItem(imageName: "history", highImageName: "dylogo", size: size)
        let searchItem = UIBarButtonItem.creatItem(imageName: "qrcode-2", highImageName: "qrcode-2", size: size)
        
        //let qrcodeItem = UIBarButtonItem.creatItem(imageName: "search", highImageName: "search", size: size)
        
        navigationItem.rightBarButtonItems = [searchItem]
        navigationController?.navigationBar.barTintColor = .white
    }
    
}

//设置了当前类为PageTitleView对象的代理,需要遵守协议,并实现协议方法-p5.d11
//HomeViewController来处理PageTitleView与PageContentView之间的逻辑(点击或滚动label显示相应的PageContentView).d11
extension HomeVC: PageTitleViewDelegate {
    
    //index:点击分页栏label时,接受从PageTitleView中通过协议传过来的点击的Label的index,再传给setCurrentIndex使用
    func pageTitleView(titleView: PageTitleView, selectedLabelIndex index: Int) {
        
        //f2.1-点击分页栏Label时调用该方法,并传入点击的Labdel的index
        pageContentView.setCurrentIndex(currentIndex: index)
    }

}

//MARK: - 遵守PageContentViewDelegate协议
//协议传值x5
extension HomeVC: PageContentViewDelegate {
    //实现方法,可以从该方法中的参数拿到传过来的值.并给PageTitleView使用.d12
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        //PageTitleView调用方法,使用通过协议穿过来的值(即完成了协议传值从PageContentView到PageTitleView).d12
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
}
