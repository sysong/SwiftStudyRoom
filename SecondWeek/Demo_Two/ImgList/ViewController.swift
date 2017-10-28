//
//  ViewController.swift
//  ImgList
//
//  Created by 云松 on 2017/10/28.
//  Copyright © 2017年 kwl. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

/// 窗口宽度
var kScreen = UIScreen.main.bounds.size.width

/// 获取视图高度
func sys_hight(_ view : UIView) ->CGFloat { return view.frame.height }

class ViewController: UIViewController {

    fileprivate static let bag = DisposeBag()
    
    fileprivate static let indentify = "UICollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //初始化
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = UICollectionViewScrollDirection.horizontal
        flow.itemSize = CGSize(width: kScreen - 30, height: sys_hight(self.collectionView) - 60)
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.collectionViewLayout = flow
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewController.indentify)
        
        //数据源
        let items = Observable.just(
            (0..<4).map { "\($0 + 1)" }
        )
        
        //绑定
       items.bind(to: collectionView.rx.items){(collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.indentify, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(Double(arc4random()%255)/255.0), green: CGFloat(Double(arc4random()%155)/255.0), blue: CGFloat(Double(arc4random()%55)/255.0), alpha:1.0)
           cell.layer.masksToBounds = true
           cell.layer.cornerRadius = 5.0
        return cell
       }.disposed(by: ViewController.bag)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

