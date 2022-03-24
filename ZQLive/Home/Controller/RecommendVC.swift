//
//  RecommendVC.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/10.
//

import UIKit
import Alamofire
import Kingfisher

//item之间的列间距,宽,高(大概估计的值).d14
private let kItemMargin: CGFloat = 10
private let kItemW = (kScreenW - 3 * 10) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kCycleViewH: CGFloat = kScreenH * 3 / 16 //轮动器的大概高度.d23
private let kGameViewH: CGFloat = 90 //估计的值

private let kNormalCellID = "kNormalCellID"
private let kHeaderViewH: CGFloat = 50
private let kHeaderViewID = "kHeaderViewID"
private let kPrettyCellID = "kPrettyCellID"

//"推荐"对应的控制器,需要将该控制器加入到UICollectionView的cell(item)中.d14
//继承BaseVC父类,里面封装了加载动画功能.d83
class RecommendVC: BaseVC {
    //MARK: - 懒加载属性
    //通过闭包创建一个懒加载的view的对象,然后再addSubview在当前的view上面
    //MVVM5.2 Recommend控制器对应的ViewModel属性(MVVM模式),用来管理网络请求.d19
    private lazy var recommendVM = RecommendViewModel()
    
    //创建需要添加在当前控制器中的view对象
    private lazy var collectionView: UICollectionView = { [weak self] in
        //创建布局.d14
        let layout = UICollectionViewFlowLayout()
        //设置所有的item的尺寸,可以在协议方法中动态的分别设置每一个item的size.d16
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 5 //最小行间距
        layout.minimumInteritemSpacing = kItemMargin //最小列间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //cell内边距(距离屏幕左右两侧的距离)
        //t3.1.每个区的头的布局(并没有view,需要在加一个view).d14
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        
        //创建UICollectionView对象
        //frame为当前View的frame,可以使用self.view.bounds,需要防止循环引用
        let collectionView = UICollectionView(frame: (self!.view.bounds), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        //需要使用UICollectionViewDelegateFlowLayout协议中的动态设置item的尺寸的方法.d16
        //因为该协议继承自UICollectionViewDelegate,所以使用时也是设置delegate为self
        collectionView.delegate = self
        //collectionView的宽和高都随着父视图的拉伸而拉伸,避免里面的item最下方显示不全.d14
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //设置collectionview的内边距，让轮播器一直都处于显示状态，而不是向下拖动才显示.d23
        //collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
        
        //注册cell也可以写在此处,这里是懒加载效果更好.d14
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)
        
        
        //t3.2.注册区的头视图的headerView,通过UICollectionReusableView(headerView).d14
        //使用下面的.d15中注册的xib文件中的headerView
        //collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        //t3.2.注册区的头视图headerView,通过xib创建的headerView.d15
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        //注册通过xib文件创建的cell(颜值中的cell).d16
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        
        return collectionView 
        
    }()
    
    private lazy var cycleView: RecommendCycleView = {
        //调用封装好的recommendCycleView()方法,即用xib创建对象的方法.d23
        let cycleView = RecommendCycleView.recommendCycleView()
        //cycleView.translatesAutoresizingMaskIntoConstraints = false
        //设置view的frame.任何一个控件都需要frame才能显示
        //轮播器是加在collectionView里的,且是在它的最上面,collectionCell的y坐标为0,所以相对于父视图collectionView,它的y为负值.d23
        //轮播器下面又添加了RecommendGameView,所以轮播器的y值需要加上gameView的高
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    
    //将gameView加到collectionView上面,才能正确显示.d27
    private lazy var gameView: RecommendGameView = {
        
        let gameView = RecommendGameView.recommendGameView()
        
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        
        
        return gameView
    }()
    
    //MARK: - 自定义对象
    let jsonToModel = RecommendViewModel.jsonToModel()
    
    //MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //也可以注册在上面的懒加载属性里面(提高性能)
        //注册cell.d14
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)
        //注册通过xib文件创建的cell(普通的cell)
        collectionView.register(UINib(nibName: "CollectionNormallCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        
        //设置UI
        setupUI()
        
        //MVVM5.4发送网络请求
        loadData()
    }
    
}

//MARK: - 设置UI界面内容
extension RecommendVC {
    
    //在当前控制器中添加UIView对象,添加之后才能进行显示.
    //父类中也有该方法,此处覆写父类中的该方法,同时也需要调用父类中的该方法,用于使用父类中改方法功能.d83
    //注意0.1.2的执行顺序不能调换.d83
    override func setupUI() {
        //0.给父类中的内容view的引用赋值,用于一开始加载完数据之前先隐藏掉collectionView.d83
        contentView = collectionView
        //1.将UICollectionView添加到控制器的view中
        self.view.addSubview(collectionView)
        //2.调用并执行父类中的方法
        super.setupUI()
        
        //3.将CycleView添加到UICollectionView中,因为它可以随着collectionView一起向上滚动,不能直接加到根视图RecommendVC上.d23
        collectionView.addSubview(cycleView)
        
        //4.将RecommendGameView对象添加到collectionView中.d27
        collectionView.addSubview(gameView)
        
        //5.设置collectionview的内边距，让轮播器一直都处于显示状态，而不是向下拖动才显示,也可设置带闭包中.d23
        //让collectionview的内边距去显示cycleView和gameView
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
        
        
        
    }
}

//MARK: - 请求数据
//MVVM5.3使用封装的Alamofire工具类.d19
extension RecommendVC {
    
    private func loadData() {
        //1.请求推荐数据
        //使用的是MVVM模式,创建RecommendVC控制对应的ViewModel部分,将网络请求部分放在其中,可给当前控制器减负,便于维护
        //e3.3在requestData中添加了逃逸闭包参数,用于当请求完成时,执行一个回调函数,即这里的reloadData.d21
        recommendVM.requestData {
            self.collectionView.reloadData()
            
            //将数据传递给RecommendGameView,原课程中使用的是推荐这部分的数据来填充RecommendGameView.d28
            //self.gameView.groups2 = self.recommendVM.anchorGroups
        }
        
        //2.请求轮播数据.d24
        //调用该方法时候,可以在方法里面再执行方法,是因为该方法中有一个闭包参数,且是唯一也是最后一个参数.故可在方法的最后再执行方法
        recommendVM.requestCycleData {
            
            //self.cycleView.cycleModels = self.recommendVM.cycleModels
            self.cycleView.cycleModels2 = self.recommendVM.cycleModels2
            //将数据传递给RecommendGameView,使用轮播器中的数据来填充RecommendGameView.d28
            self.gameView.groups2 = self.recommendVM.cycleModels2
            
            //执行到此处说明网络数据请求已经完成,可以隐藏掉加载动画,并显示内容View.d83
            self.loadDataFinished()
        }
    
    }
}

//MARK: - 遵守数据源协议
extension RecommendVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recommendVM.anchorGroups.count //.d21
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendVM.anchorGroups[section]
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //0.取出模型对象,从推荐的主播组中.d22
        let group = recommendVM.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        var cell: CollectionViewBaseCell!
        //取出cell(有两种cell一种最上面普通的cell,一种颜值里面的cell).d16.d22
        if indexPath.section == 1 {
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            cell.anchor = anchor
            
            //setCellImageNickNameOnLineTitle2(index: indexPath.item, cell: cell as! CollectionPrettyCell)
            
            
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormallCell
            cell.anchor = anchor
            
            if indexPath.item == 0{
                setCellImageNickNameOnLineTitle(index: 0, cell: cell as! CollectionNormallCell)

            }else if indexPath.item == 1{
                setCellImageNickNameOnLineTitle(index: 1, cell: cell as! CollectionNormallCell)

            }else if indexPath.item == 2{
                setCellImageNickNameOnLineTitle(index: 2, cell: cell as! CollectionNormallCell)

            }else if indexPath.item == 3{
                setCellImageNickNameOnLineTitle(index: 3, cell: cell as! CollectionNormallCell)

            }else{
                cell.nickName.text = ""
                cell.onlineBtn.setTitle("", for: .normal)

            }

        }
        //将模型赋值给cell
        cell.anchor = anchor
        
        //        cell.iconImageView.image = UIImage(named: <#T##String#>)
        //
        
        return cell
        
    }
    
    //t3.3.创建Section的头headerView的数据源方法.d14
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //kHeaderViewID注册为了区的头view的标识符,所以可以用该方法创建区的头视图
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        //取出模型
        headerView.group = recommendVM.anchorGroups[indexPath.section]
        
        
        
        return headerView
    }
}

//可以动态的设置每一个item的size.d16
extension RecommendVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
            
        }else {
            return CGSize(width: kItemW, height: kNormalItemH)
        }
    }
    
}

extension RecommendVC {
    
    //填充cell的测试方法
    func setCellImageNickNameOnLineTitle(index: Int,cell: CollectionNormallCell){
        
        cell.nickName.text = jsonToModel.roomList[index].nickName
        
        cell.onlineBtn.setTitle("\(index * 1000)" , for: .normal)
        
        cell.roomNameLabel.text = jsonToModel.roomList[index].roomName
        
        let iconURL = URL(string: jsonToModel.roomList[index].verticalSrc)
        
        cell.iconImageView.kf.setImage(with: iconURL)
    }
    
    //填充cell的测试方法
    func setCellImageNickNameOnLineTitle2(index: Int,cell: CollectionPrettyCell){
        
        cell.nickName.text = jsonToModel.roomList[index].nickName
        
        cell.onlineBtn.setTitle("\(index * 1000)" , for: .normal)
    
        let iconURL = URL(string: jsonToModel.roomList[index].avatarSmall)
        
        cell.iconImageView.kf.setImage(with: iconURL)
    }
}

extension RecommendVC: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        let roomVC = RoomNormalVC()
        
        navigationController?.pushViewController(roomVC, animated: true)
        
        
    }
}
