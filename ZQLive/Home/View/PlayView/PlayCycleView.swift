//
//  PlayCycleView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/7.
//

import UIKit

class PlayCycleView: UIView {
    
    var playCycleTimer: Timer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //监听PlayVC中loadData方法中playCycleView.playCycleModels的值变化
    var playCycleModels: [PlayCycleModel]? {
        
        didSet{
            
            //必须要监听playCycleModels值的变化,当有值时,必须刷新数据源方法,才能渲染出cell
            collectionView.reloadData()
            
            pageControl.numberOfPages = playCycleModels?.count ?? 0
            
            //
            let indexPath = IndexPath(item: (playCycleModels?.count ?? 0) * 10, section: 0)
            
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            removePlayCycleTimer()
            addcycleTimer()
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //必须要有此设置,PlayCycleView显示出来
        autoresizingMask = AutoresizingMask(rawValue: .zero)
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "PlayCycleViewCell", bundle: nil), forCellWithReuseIdentifier: kPlayCycleViewCellID)
        //自动分页功能,设置后,滚动collectionView时,cell不会连续无界限的滚动
        collectionView.isPagingEnabled = true
        
        //滚动方向需要使用布局对象UICollectionViewFlowLayout来设置
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
    }
    
   
    
}

extension PlayCycleView: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (playCycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayCycleViewCellID, for: indexPath) as! PlayCycleViewCell
        
        //因为有(playCycleModels?.count ?? 0) * 10000个cell,所以为了防止数据越界,需要进行该处理.d26
        cell.playCycleModel = playCycleModels![indexPath.item % playCycleModels!.count ]
        
        return cell
    }
    
}

extension PlayCycleView: UICollectionViewDelegateFlowLayout{
    //设置item的尺寸方法
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //尺寸需要在代码中设置,在XIB中设置的尺寸有一点问题,item的大小会大一些.d23
        let itemSize = collectionView.bounds.size
        
        return itemSize
    }
}


//监听collectionView的滚动
extension PlayCycleView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //滚动到一半的时候,pageController就跳到下一个,往回滚动也是一样效果
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
    
        
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (playCycleModels?.count ?? 1)
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //手动滚动时移除定时滚动器
        removePlayCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //结束手动滚动时,再加上定时滚动器
        addcycleTimer()
    }
}


//定时器相关操作,实现无线轮播
extension PlayCycleView {
    
    //添加定时器
    private func addcycleTimer(){
        
    playCycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        
        RunLoop.main.add(playCycleTimer!, forMode: RunLoop.Mode.common)
    
    }
    
    private func removePlayCycleTimer() {
        
        playCycleTimer?.invalidate()
        playCycleTimer = nil
        
    }
    
    @objc func scrollToNext() {
        
        let currentOffsetX = collectionView.contentOffset.x
        
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        
    }
}
