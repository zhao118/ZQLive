//
//  GameVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/2.
//

import UIKit

//"游戏"控制器.d70
class GameVC: UIViewController {
    
    //private：只在本类中使用,fileprivate:同一个文件中可以使用，可以不再同一个类中,比如类的扩展中同样可以使用
    fileprivate let kCellH = kScreenW / 3
    fileprivate let kCellW = kScreenW / 3
    private let kHeaderViewID = "kHeaderViewID"
    private let kHeaderViewH = 50
    
    //MARK: - 懒加载属性
    //创建游戏模型对象.d71
    fileprivate lazy var gameViewModel = GameViewModel()
    
    //创建UICollectionView对象,使用闭包创建.d70
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        
        //1.创建布局
        let layout = UICollectionViewFlowLayout()
        //因为整个内容视图就是一个item故大小为自身的size.可以左右滚动(分页显示)
        //2.2强制解包self:解决闭包引起的循环强引用.d11
        layout.minimumLineSpacing = 0 //item的行间距
        layout.minimumInteritemSpacing = 0 //item的列间距
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: kCellW, height: kCellW)
        
        //创建可复用的HeaderView
        //用代码设置UICollectionView对象的区的HeaderView.d72
        //H1.创建HeaderView的Size;H2.注册HeaderView复用的标识符;H3.数据源方法中创建HeaderView.d72
        layout.headerReferenceSize = CGSize(width: kScreenW, height: 50)
        
        //创建collectionView
        let collectionView = UICollectionView(frame: (self?.view.bounds)!, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        //让collectionView中最下面的cell展示完全.d71
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //2.创建UICollectionView
        collectionView.dataSource = self //遵守数据源协议,才能显示具体的数据内容.d10
        
        //H2
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameVCCellID)//注册
        
        return collectionView
    }()
    
    //创建上面的单个的顶部HeaderView-常V用iew .d73
    //1.实例化HeaderView, 2.创建它的frame, 3.添加到CollectionView里面(添加到collectionView上才能随CollectionView一起滚动)
    fileprivate lazy var topHeaderView: CollectionHeaderView = {
       
        let topHeaderView = CollectionHeaderView.collectionHeaderView()
        topHeaderView.frame = CGRect(x: 0, y: -(kHeaderViewH + kGameVCRecommendGameGiewH), width:Int(kScreenW), height: kHeaderViewH )
        topHeaderView.iconImageView.image = UIImage(named: "littleIcon")
        topHeaderView.titleLabel.text = "常见"
        topHeaderView.moreBtn.isHidden = true
        
        return topHeaderView
    }()
    
    //创建"常用"里面的游戏的View,里面是一个collectionView.复用RecommendGameView来创建.d73
    //1.实例化gameView, 2.创建它的frame, 3.添加到CollectionView里面(添加到collectionView上才能随CollectionView一起滚动)
    fileprivate lazy var gameView: RecommendGameView = {
       
        let gameView = RecommendGameView.recommendGameView()
        gameView.frame = CGRect(x: 0, y: -CGFloat(kGameVCRecommendGameGiewH), width: kScreenW, height: CGFloat(kGameVCRecommendGameGiewH))
        
        
        return gameView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        setUI()
        
        loadData()
    }
    
}

extension GameVC {
    
    fileprivate func setUI() {
        
        self.view.addSubview(collectionView)
        //添加顶部的HeaderView.d73
        collectionView.addSubview(topHeaderView)
        //
        collectionView.addSubview(gameView)
        
        //设置Collection的内边距,让HeaderView在不拖动的情况下也能查看.d73
        collectionView.contentInset = UIEdgeInsets(top: CGFloat(kHeaderViewH + kGameVCRecommendGameGiewH), left: 0, bottom: 0, right: 0)
        
        

    }
}

//MARK: - 请求数据
extension GameVC{
    //.d71
    fileprivate func loadData() {
       
        gameViewModel.laodaAllGameData {
            
            //展示全部游戏数据
            self.collectionView.reloadData()
            
            //展示常用游戏
            self.gameView.groups2 = self.gameViewModel.gameModels2
            
            //执行到此处说明网络数据请求已经完成,可以隐藏掉加载动画,并显示内容View.d83
            //self.loadDataFinished()
            
        }
    }
}

extension GameVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return gameViewModel.gameModels2.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //使用CollectionGameCell中的数据来填充GameVC中的cell.d71
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameVCCellID, for: indexPath) as! CollectionGameCell
        
        let gameModel = gameViewModel.gameModels2[indexPath.item]
        
        cell.group = gameModel
        
        return cell
    }
    
    //H3.创建区的HeaderView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        headerView.titleLabel.text = "全部"
        
        headerView.iconImageView.image = UIImage(named: "littleIcon")
        headerView.moreBtn.isHidden = true
        
        return headerView
    }
}

