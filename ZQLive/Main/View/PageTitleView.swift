//
//  PageTitleView.swift
//  ZQLive
//
//  Created by ZhaoQ on 2022/2/9.
//

import UIKit

//MARK: - 定义协议
//遵守class:该协议只能被类遵守(否则还可以被结构体,枚举遵守),且可以将delegate属性,定义为可选类型.d11
//使用协议传值.从当前类传到HomeViewController中给PageContentView使用.创建协议-p1.d11
protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedLabelIndex index: Int)
}

//MARK: - 定义常量
private let kscrollLineH: CGFloat = 2 //滚动条的高度
//使用RGB表示颜色,主要是为了做滚动时候的分页栏Label的颜色的渐变效果.d13
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85) //元祖类型,灰色的RGB值.d13
private let kSelectedColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)//橘色RGB值


//MARK: - 定义PageTitleView类
//显示分页栏的view,是一个UIScrollView对象,位于状态栏下面,里面含有titles
class PageTitleView: UIView {
    
    //MARK: - 定义属性
    private var currentLabelIndex = 0 //当前label的下标(索引)值
    private var titles: [String]
    private lazy var titleLabels: [UILabel] = []
    weak var delegate: PageTitleViewDelegate?  //代理属性最好定义为weak弱引用类型-p2.d11
    
    //MARK: - 懒加载属性(因为会多次使用,所以定义为懒加载,使用时才加载,提升性能)
    //使用闭包创建对象
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false //关闭水平方向的滚动指示器
        scrollView.scrollsToTop = false //关闭滚动到顶部
        scrollView.bounces = false //关闭反弹
        return scrollView
        
    }()
    
    //滚动条
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = .orange
        return scrollLine
    }()
    
    //MARK: - 自定义构造函数.d9
    //将UIView自带的init(frame:CGRect)构造函数进行扩展
    init(frame: CGRect,titles: [String]) {
        self.titles = titles
        //需要调用父类的init(frame:)
        super.init(frame: frame)
        
        //初始化构造器中调用
        setupUI()
    }
    
    /* 必要初始化器，一般会出现在继承了遵守NSCoding protocol的类，比如UIView系列的类、UIViewController系列的类
     为什么一定要添加：
     这是NSCoding protocol定义的，遵守了NSCoding protoaol的所有类必须继承。只是有的情况会隐式继承，而有的情况下需要显示实现。
     什么情况下要显示添加：
     当我们在子类定义了指定初始化器(即默认的构造方法.包括自定义和重写父类指定初始化器.这里是自定义了构造函数init)，那么必须显示实现required init?(coder aDecoder: NSCoder)，而其他情况下则会隐式继承，我们可以不用理会。
     什么情况下会调用：
     当我们使用storyboard实现界面的时候，程序会调用这个初始化器。
     注意要去掉fatalError，fatalError的意思是无条件停止执行并打印。*/
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 设置UI界面
extension PageTitleView {
    private func setupUI() {
        //1.添加UIScrollView.d9
        addSubview(scrollView)
        //bounds:边界矩形，用于描述视图在其自己的坐标系中的位置和大小
        //frame:框架矩形，描述视图在父视图坐标系中的位置和大小
        //滚动范围不超过自身范围
        scrollView.frame = bounds
        //2.添加title对应的label
        setupTitleLabels()
        //3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        //0.确定label的部分frame的值.(把不需要循环遍历的部分分离出来,提高性能).d9
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kscrollLineH
        let labelY: CGFloat = 0
        //enumerated():返回索引index和元素title
        for (index,title) in titles.enumerated() {
            
            //1.创建UILabel
            let label = UILabel()
            //2.设置label的属性.tag:一个整数,可以用来标识应用的视图对象
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16) //默认是17
            //label.textColor = UIColor.black
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2) //从元祖中取值.灰色.d13

            label.textAlignment = .center
            //3.设置label的frame
            //当前分页栏PageTitleView视图的frame的宽除以titles的数量
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            //4.将label添加到ScrollView中.d9
            scrollView.addSubview(label)
            //为了方便后面拿到第一个label,所以创建一个数组,将遍历的到的label加入数组
            titleLabels.append(label)
            
            //给label添加手势(天机事件).d11
            label.isUserInteractionEnabled = true //允许label进行手势交互
            //创建手势
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            //依次加入手势
            label.addGestureRecognizer(tapGes)
            
        }
        
    }
    
    private func setupBottomLineAndScrollLine() {
        //1.添加底线.d9
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        let lineH = CGFloat(1)
        bottomLine.frame = CGRect(x: 0, y: frame.height, width: frame.width, height:lineH )
        addSubview(bottomLine)
        
        //2.添加滚动条scrollLine
        //2.1获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        //设置第一个label的颜色,表示为滚动条选中状态
        //firstLabel.textColor = .orange
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)//用rgb值表示橘色
        
        //2.2设置滚动条的剩余属性.y:当前分页栏的frame的高减去滚动条的高度
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kscrollLineH, width: firstLabel.frame.width, height: firstLabel.frame.height)
        
    }
    
}


//MARK: - 监听label的点击.d11
extension PageTitleView {
    
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        
        //0.获取当前点击的label(通过手势的view属性)
        guard let currentLabel = tapGes.view as? UILabel else { return }
        //1.如果重复点击同一个title,那么直接返回,保证颜色还是处于选择状态
        if currentLabel.tag == currentLabelIndex { return }
        
        //2.获取之前的label
        let oldLabel = titleLabels[currentLabelIndex]
        //3.切换文字颜色.点击的label的text为Orange,非点击的为darkGray
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)//用rgb值表示橘色
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)//
        //4.最新label的下标值.tag:当前点击的视图(label)的的整数下标,默认从0开始
        currentLabelIndex = currentLabel.tag
        //5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //6.点击title时通知代理,并传入点击的label的index-p3.d11
        delegate?.pageTitleView(titleView: self, selectedLabelIndex: currentLabelIndex)
        
        
    }
}

//MARK: - 对外暴露的方法
//使用利用协议从PageContentView中传过来的值.d12
extension PageTitleView {
    //在左右滑动时会触发该方法,因为在UICollectionViewDelegate的scrollViewWillBeginDragging中,使用代理调用了协议中的方法.d13
    func setTitleWithProgress(progress: CGFloat,sourceIndex: Int, targetIndex: Int) {
        //1.取出sourceLabel原来的label,targetLabel滚动后的目标label.d13
        let sourceLabel = titleLabels[sourceIndex]
        let targetlabel = titleLabels[targetIndex]
        
        //2.在左右滑动时,处理滑块(滚动条)逻辑,即滑动内容视图时,滚动条也要随之移动
        let moveTotalX = targetlabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //3.Label的颜色的渐变(较复杂).d13
        //3.1取出从橘色到灰色的变化范围,(元祖里面分别为红,绿,蓝的变化范围)
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        
        //3.2sourceLabel的渐变化颜色(滑动视图时,label从橘色到灰色).progress滚动的进度
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress, g: kSelectedColor.1 - colorDelta.1 * progress , b: kSelectedColor.2 - colorDelta.2 * progress)
        //3.3targetLabel的渐变化颜色(从灰色到橘色)
        targetlabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        //4.记录最新的index
        currentLabelIndex = targetIndex
    }
}
