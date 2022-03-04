//
//  RecommendCycleView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/18.
//

import UIKit

//推荐页上面的无线轮播器的制作.d23
class RecommendCycleView: UIView {
    let kCycleCellID = "cell"

    //MARK: - 定义属性,并监听
        
    //定时器.制作无线轮播器的自动滚动.d26
    var cycleTimer: Timer?
    var cycleModels2: [CycleModel2]?{
        //从RecommendVC中的loadData()中设置cycleModels的值,并在该处进行监听.d24
        
        didSet{
            //监听到属性cycleModels的值发生改变时,进行的操作
            collectionView.reloadData()
            //pageControl的个数
            pageControl.numberOfPages = cycleModels2?.count ?? 0
            //默认滚动到中间某一个位置.实现从左边第一个向左边继续无线滚动.d26
            let indexPath = IndexPath(item: (cycleModels2?.count ?? 0) * 10, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
 
            //添加定时器.添加之前需要先移除.d26
            removeCycleTimer()
            addCycleTimer()
        }
    
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //从xib中开始加载时就执行.d23
        //设置该控件不随着父控件的拉伸而拉伸,为了能正常显示轮播view.d23
        autoresizingMask = AutoresizingMask(rawValue: .zero)
        
        collectionView.dataSource = self
        
        //UICollectionViewDelegateFlowLayout的使用,它是继承UICollectionViewDelegate,故同样要设置delegate.d23
        collectionView.delegate = self
        
        //默认也是允许分页的.XIB中也可以进行相应的属性设置.d23
        collectionView.isPagingEnabled = true
        
        //滚动方向需要使用布局对象UICollectionViewFlowLayout来设置
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        

        //没有创建关联的UICollectionViewCell对象,就直接使用UICollectionViewCell.self.d23
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
    }
    
    
    
}

//MARK: - 提供一个快速创建view的类方法.d23
extension RecommendCycleView {
    
    class func recommendCycleView() -> RecommendCycleView {
        
        //使用xib快速创建类(RecommendCycleView对象)的方法
        let recommendCycleView = Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as!
            RecommendCycleView
        
        return recommendCycleView
    }
    
}

//MARK: - 数据源方法
extension RecommendCycleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       //无线轮播循环滚动.d26
        return (cycleModels2?.count ?? 0) * 10000
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.blue
         
        //实现无线滚动器循环滚动.d24.d25.d26
        cell.cycleModel2 = cycleModels2![indexPath.item % cycleModels2!.count]
        
        return cell
    }

    
}
//MARK: - 协议方法
extension RecommendCycleView: UICollectionViewDelegateFlowLayout{
    //设置item的尺寸方法
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let itemW = collectionView.bounds.width
        //let itemH = collectionView.bounds.height
        //return CGSize(width: itemW, height: itemH)
        
        //尺寸需要在代码中设置,在XIB中设置的尺寸有一点问题,item的大小会大一些.d23
        let itemSize = collectionView.bounds.size
        
        return itemSize
    }
}

//遵守UICollectionView的代理协议
extension RecommendCycleView: UICollectionViewDelegate {
    
    //监听CollectionView的滚动.用于制作pageControll的滚动.d25
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //1.获取滚动的偏移量,只是在X轴方向滚动
        let offsetX = scrollView.contentOffset.x
        //当滚到一半的时候,pageControl就跳到下一个
        //let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
    
        //2.计算pageControl的currentIndex
        //取余,实现pageControl一同循环滚动.d26
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) %  (cycleModels2?.count ?? 1)
    }
    
    //监听用户的拖拽,当用户在手动滚动轮播器的时候,就停止自动滚动.d26
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    //监听用户的拖拽,当结束拖拽时,再加上定时器用于自动轮播.d26
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

//MARK: - 对定时器的操作.d26
extension RecommendCycleView {
    //添加定时器
    private func addCycleTimer() {
        //三秒开始轮播,self:监听当前对象
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        
        RunLoop.main.add(cycleTimer!, forMode: RunLoop.Mode.common)
        
        
        
    }
    //移除定时器(里面包含有滚动的方法scrollToNext())
    private func removeCycleTimer() {
        //停止倒计时.开始倒计时之后,还需要停止
        cycleTimer?.invalidate()
        cycleTimer = nil
        
    }
    
    //轮播器滚动到下一个view
    @objc func scrollToNext() {
        //1.获取要滚动的偏移量
        //1.1 起始位置偏移量
        let currentOffsetX = collectionView.contentOffset.x
        //1.2 滚动到的位置的偏移量
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        //2.滚动到该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
