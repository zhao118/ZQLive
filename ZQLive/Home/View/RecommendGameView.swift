//
//  RecommendGameView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/3/1.
//

import UIKit

//推荐项下的轮播器下的游戏选项View.d27
class RecommendGameView: UIView {
    
   //内边距
    private let kEdgeInsetMargin: CGFloat = 5

    //使用轮播器中的数据来填充RecommendGameView,原课程中使用的是其他数据来填充.d28
    //轮播器中的数据封装为了模型,可以直击从模型中获取
//    var groups: [AnchorGroup]?{
//
//        didSet{
//            //监听groups2值的改变,若发生改变,则刷新数据源方法.d28
//            collectionView.reloadData()
//        }
//    }
    
    
    //监听RecommendVC中传过来的groups2的值
    var groups2: [CycleModel2]? {
        didSet{
            
            //移除groups2中的前两组数据,不展示.连续调用两次,就可移除前面两个元素.d28
            //这里只移除一个
            //groups2?.removeFirst()
            groups2?.removeFirst()
           
            //直接创建一个模型对象,设置模型对象的tag_name = "更多" ,再将模型对象加入到groups2数组中
            
            //Codable.-2创建一个结构体类型的模型对象,实例化模型对象的方法,且该对象继承的是Codable
            //实例化时,需要传入结构体中属性的参数,该处只是想增加一个模型属性title的值,所以其他的设置为了nil
            //在创建模型的时候,pic_url,room的类型也要设置为可选类型这里才能赋值为nil
            let moreGroup = CycleModel2(title: "更多", pic_url: nil, room: nil)
            
            groups2?.append(moreGroup)
            
            collectionView.reloadData()
        }
    }
   

    //在XIB中将CollectionView添加到了当前的RecommendGameView中
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件不随着父控件的拉伸而拉伸,为了能正常显示轮播view.d27
        autoresizingMask = AutoresizingMask(rawValue: .zero)
        
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kCollectionGameCell)
        
        //内边距.d28
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: kEdgeInsetMargin)
    }

}

//提供一个快速创建的类方法,来创建通过XIB创建的View对象.d27
extension RecommendGameView {
    
    class func recommendGameView() -> RecommendGameView{
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
    
    
}

extension RecommendGameView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //.d28
        return groups2?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCollectionGameCell, for: indexPath) as! CollectionGameCell
       
        //.d28
        let group = groups2![indexPath.item]
        cell.group = group
        
        //自定义cell,将这里的group传给cell中的group(在cell要创建一个接受group的对象,并使用监听来设置cell的控件)
        //cell.backgroundColor = indexPath.item % 2 == 0 ? .red : .blue
        return cell
    }
    
    
}
