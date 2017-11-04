//
//  ViewController.swift
//  Demo3
//
//  Created by 云松 on 2017/11/4.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit


let heightList: Array<CGFloat> = {
    var list = [CGFloat]()
    for i in 0..<20 {
        list.append(CGFloat(arc4random()%100 + 50))
    }
    return list
}()
class Layout: UICollectionViewFlowLayout {
    //宽度确定
    let width = (UIScreen.main.bounds.size.width - 12)/2
    //高度随机的
    var height: CGFloat = 0.0, x: CGFloat = 5.0, yLeft : CGFloat = 5.0, yRight: CGFloat = 5.0,
    reLeft: CGFloat = 5.0, reRight: CGFloat = 5.0
    override func prepare() {
        self.scrollDirection = .vertical
        self.collectionView?.contentInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        super.prepare()
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let list = super.layoutAttributesForElements(in: rect)
        //处理数据
        guard let attList = list else {
            return list
        }
        //处理数据
        attList.forEach { attribute in
           dealPosition(attribute)
        }
        //报错是什么鬼the flow layout subclass Demo3.Layout is modifying attributes returned by UICollectionViewFlowLayout without copying them
        return attList
    }

    func dealPosition(_ attributes: UICollectionViewLayoutAttributes){
        
        let row = attributes.indexPath.row
        guard heightList.count > row else {
            return
        }
        self.height = heightList[row]
        //Y坐标
        if (row == 0){
            x = 5.0
            yLeft = 5.0
            reLeft = 5.0
            reLeft = height + yLeft
        }else if row == 1 {
            yRight = 5.0
            reRight = 5.0
            reRight = height + yRight
        }
        
        if row % 2 == 0 && row != 0 {
            //恢复到初始值
            x = 5.0
            //计算y值.第一排的y值
            yLeft = reLeft + 10.0
            
            reLeft = yLeft + height
        }
        
        if row % 2 == 1 && row != 1 {
            //计算y值.第二排的y值
            yRight = reRight + 10.0
            
            reRight = yRight + height
        }
        
        let yPos = row % 2 == 0 ? yLeft: yRight
        attributes.frame = CGRect(x: x, y: yPos, width: self.width, height: height)
        //X坐标
        x = x + width + 1.0
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: reLeft > reRight ? reLeft:reRight)
    }
}


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var colView: UICollectionView!
    
    fileprivate let cellIndentify = "CollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = Layout()
        self.colView.setCollectionViewLayout(layout, animated: true)
        self.colView.register(UINib.init(nibName: cellIndentify, bundle: nil), forCellWithReuseIdentifier: cellIndentify)
        self.colView.alwaysBounceVertical = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentify, for: indexPath) as! CollectionViewCell
         return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

