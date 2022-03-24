//
//  PlayVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/7.
//

import UIKit

class PlayVC: UIViewController {
    
    lazy var playViewModel = PlayViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        loadData()
        
    }
    
    //创建需要添加在当前控制器中的view对象
    @objc lazy var collectionView: UICollectionView = { [weak self] in
        //创建布局.d14
        let layout = UICollectionViewFlowLayout()
        //设置所有的item的尺寸,可以在协议@objc 方法中动态的分别设置每一个item的size.d16
        layout.itemSize = CGSize(width: kPlayItemW, height: KPlayNormalItemH)
        layout.minimumLineSpacing = 5 //最小行间距
        layout.minimumInteritemSpacing = kPlayItemMargin
        //cell距离四周的距离(cell距离collectionView的距离)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //cell内边距(距离屏幕左右两侧的距离)
        //t3.1.每个区的头的布局(并没有view,需要在加一个view).d14
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kPlayHeaderViewH)
        
        //创建UICollectionView对象
        //frame为当前View的frame,可以使用self.view.bounds,需要防止循环引用
        let collectionView = UICollectionView(frame: (self!.view.bounds), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
      
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //collectionView距离四周的距离用于显示轮播器的内边距
        collectionView.contentInset = UIEdgeInsets(top: kPlayCycleViewH , left: 0, bottom: 0, right: 0)
        
        //t3.2.注册区的头视图headerView,通过xib创建的headerView.d15
        collectionView.register(UINib(nibName: "PlayHeaderViewCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kPlayHeaderViewID)
        
        //注册UICollectionViewcell
        collectionView.register(UINib(nibName: "PlayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: kPlayCellID)
        
        return collectionView
        
    }()
    
    //轮播器
     lazy var playCycleView: PlayCycleView = {
        
        //因为是用XIB创建的View,所以必须用此方法从XIB中加载View
        let playCycleView = Bundle.main.loadNibNamed("PlayCycleView", owner: nil, options: nil)?.first as! PlayCycleView
           
        //轮播器是加在collectionView上的,所以轮播器的frame相对于父视图collectionView的frame,y轴为负数,因为要显示在collectionView的上面
        let frame = CGRect(x: 0, y: -(kPlayCycleViewH), width: kScreenW, height: kPlayCycleViewH)
        playCycleView.frame = frame
        //playCycleView.backgroundColor = .blue
        
        return playCycleView
        
    }()
}

extension PlayVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       playViewModel.playModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPlayCellID, for: indexPath) as! PlayCollectionViewCell
        

        cell.playModel =  playViewModel.playModels[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //kHeaderViewID注册为了区的头view的标识符,所以可以用该方法创建区的头视图
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kPlayHeaderViewID, for: indexPath) as! PlayHeaderViewCell
        
      
        return headerView
    }
}
    
extension PlayVC {
    
    //FunyVC中继承了当前类,且复写了该方法,要求此处需要加上@objc.d81
    @objc func setupUI() {
        
        view.addSubview(collectionView)
        
        collectionView.addSubview(playCycleView)
    }
}

extension PlayVC {
    //请求数据
    private func loadData() {
        
        //VM调用请求数据的方法
        //[self]相当于给闭包中的需要全局变量加self
        //执行了loadPlayData方法,playViewModel中的playModels数组,和playModels数据才会有值
        playViewModel.loadPlayData {
            
            //请求到数据后,需要执行的操作(完成回调方法)
            //请求到数据之后,必须进行数据源的刷新,才能进行cell的渲染
            self.collectionView.reloadData()
            
            //playCycleView中必须要监听playCycleModels值的变化,当有值时,必须刷新数据源方法,才能渲染出cell
            self.playCycleView.playCycleModels = self.playViewModel.playCycleModels
            

            //执行到此处说明网络数据请求已经完成,可以隐藏掉加载动画,并显示内容View.d83
            //self.loadDataFinished()
        }
        
    }
}
