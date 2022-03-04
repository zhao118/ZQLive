//
//  PageContentView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/9.
//

import UIKit

private let contentCellID = "contentCellID"

//用于显示分页栏每一项分页的具体内容的控制器.每一项分页栏都包含一个collectionview(又含有一个cell,cell里有一个子控制器).d10
class PageContentView: UIView {

    //定义属性,用于存放子控制器和父控制器
    private var childVCs: [UIViewController]
    private weak var parentViewController: UIViewController? //2.1解决与HomeViewController之间强引用产生的循环引用.d11
    private var startOffsetX: CGFloat = 0 //当前的PageContentView的子视图的偏移量.d12
    private var isForDidScrollDelegate = false //用于判断分页栏label的切换是通过点击Label或滑动子视图,若是点击Label就不执行Label颜色渐变的一系列方法.d13
    weak var delegate: PageContentViewDelegate? //协议传值x2
    
    //MARK: - 闭包创建懒加载属性.d10
    //创建UICollectionView对象.
    private lazy var collectionView: UICollectionView = {[weak self] in //2.1解决闭包使用self引起的循环强引用.d11
        
        //1.创建UICollection对象必须创建layout(流式布局对象)
        let layout = UICollectionViewFlowLayout()
        //因为整个内容视图就是一个item故大小为自身的size.可以左右滚动(分页显示)
        layout.itemSize = self!.bounds.size //2.2强制解包self:解决闭包引起的循环强引用.d11
        layout.minimumLineSpacing = 0 //item的行间距
        layout.minimumInteritemSpacing = 0 //item的列间距
        layout.scrollDirection = .horizontal
        
        //2.创建UICollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false //关闭滚动显示器
        collectionView.isPagingEnabled = true //分页显示(因为需左右滚动)
        collectionView.bounces = false //滚动不能超出内容区域(关闭回弹效果)
        collectionView.dataSource = self //遵守数据源协议,才能显示具体的数据内容.d10
        collectionView.delegate = self //使用代理监测collectionView的滚动.d12
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: contentCellID)//注册cell
        
        return collectionView
    }()
    
    
    //MARK: - 自定义构造函数.d10
    //自定义构造函数中增加需要添加的子控制器数组,和将子控制器加入到的父控制器两个属性
    //3.3可选类型:解决闭中使用self包引起的循环强引用.d11
    init(frame: CGRect, childVCs: [UIViewController], parentViewController: UIViewController?) {
        self.childVCs = childVCs
        self.parentViewController = parentViewController
        super.init(frame: frame)
        //设置UI
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//设置界面UI
extension PageContentView {
    private func setupUI() {
        //1.将所有的子控制器添加到父控制器中.
        for childVC in childVCs {
            parentViewController?.addChild(childVC) //2.2可选类型:解决与HomeViewController之间强引用产生的循环引用.d11
        }
        
        //2.添加UICollectionView,用于在Cell中存放控制器的view
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
}
//MARK: - 遵守UICollectionViewDataSource
extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //可以左右滚动cell,每一个子视图的大小为cell的大小,也就是pageContenView的内容视图
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.重复创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellID, for: indexPath)
        
        //因为会重复创建cell,即会多次添加cell,所以在创建之前删除之前的子视图控制器会比较好.d10
        for vc in cell.contentView.subviews {
            vc.removeFromSuperview()
        }
        
        //2.给cell设置内容
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }

}
//MARK: - 遵守UICollectionViewDelegate
extension PageContentView: UICollectionViewDelegate {
    
    //开始滚动视图时候执行.根据偏移量来判断是左滑或右滑.d12
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForDidScrollDelegate = false //滚动视图时,标记为false,即执行Label颜色渐变的方法.d13
        
       startOffsetX = scrollView.contentOffset.x //当前的偏移量.与当前的偏移量来比较得出左滑或右滑
    }
    
    //使用代理方法来监听collectionView的滚动,CollectionView发生滚动时触发(collectionView也是继承自UIscrollview,所以有滚动的特性).d12
    //如果是通过点击分页栏的label而不是滑动子视图来切换label时,不让其执行改协议方法  d13
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //判断是否是点击的分页栏的Label引起的滚动,若是点击Label就不再继续执行下面的代码,即不执行Label的颜色渐变.d13
        if isForDidScrollDelegate { return }
        //1.定义获取需要的数据
        var progress: CGFloat = 0 //滚动进度
        var sourceIndex: Int = 0 //滚动前原来的label的下标
        var targetIndex: Int = 0 //滚动到的目标label的下标
        //2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x //视图当前的偏移量
        let scrollViewW = scrollView.bounds.width //PageContentView中的一个子视图的宽度
        
        if currentOffsetX > startOffsetX { //左滑
            //1.计算progress(滚动进度).floor取出整数部分(若是1.2结果为1)
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= childVCs.count { //防止最后一个label的下标越界
                targetIndex = childVCs.count - 1
            }
            
            //如果完全滑到一个label(完全滑过一个子视图控制器)
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
            
        }else { //右滑
            //1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
        }
        
        //3.将progress,sourceIndex,targetIndex传递给PageTitleView,通过协议传值.d12
        //协议传值,通知代理,调用协议方法传入实参(在左右滑动子视图时触发)x3
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
       
    }
}

//MARK: - 对外暴露的方法.d11
extension PageContentView {
    
    //f2.2点击分页栏的label时,将调用该方法.currentIndex为点击的Label的index.从而得出collectionView的内容子视图的x坐标
    func setCurrentIndex(currentIndex: Int) {
        
        //1.记录需要禁止执行监听滚动的代理方法scrollViewDidScroll
        isForDidScrollDelegate = true
        
        //2.滚动到正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        //设置与内容视图原点的偏移量，该偏移量与接收方的原点相对应
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
        
    }
}
