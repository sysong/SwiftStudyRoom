//
//  ViewController.swift
//  Demo1
//
//  Created by 云松 on 2017/11/4.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

func getViewWidth(_ view:UIView) -> CGFloat {
    return view.frame.size.width
}

func getViewHeight(_ view:UIView) -> CGFloat {
    return view.frame.size.height
}

func getViewBottom(_ view:UIView) -> CGFloat {
    return view.frame.size.height + view.frame.origin.y
}

class ViewController: UIViewController {

    lazy var scrollView = { () -> UIScrollView in
        let scrollView = UIScrollView.init(frame: CGRect(x: 0.0, y: 200.0, width: getViewWidth(self.view), height: 200))
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    lazy var pageController = { () -> UIPageControl in
       let page = UIPageControl(frame: CGRect(x: 0, y: getViewBottom(self.scrollView), width: 100, height: 20))
        page.backgroundColor = UIColor.black
        page.center = CGPoint(x: self.view.center.x, y: page.center.y)
        return page
    }()
    
    static let tatalCount = 20
    static let space: CGFloat = 10.0
    static let pageCount: Int = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        //添加
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        //
        for i in 0..<ViewController.tatalCount {
            if i % ViewController.pageCount == 0 {
                let collectionView = { () -> UICollectionView in
                    let layout = UICollectionViewFlowLayout()
                    layout.itemSize = CGSize(width: ((getViewWidth(self.scrollView) - (CGFloat(ViewController.pageCount - 2) * ViewController.space))/CGFloat(ViewController.pageCount/2)) , height: (getViewHeight(self.scrollView) - ViewController.space * 3)/2)
                    layout.scrollDirection =  .vertical
                    layout.sectionInset = UIEdgeInsets(top: ViewController.space, left: ViewController.space, bottom: ViewController.space, right: ViewController.space)
                    let collectionView = UICollectionView.init(frame: CGRect(x: CGFloat(CGFloat(i/8) * getViewWidth(self.view)), y: 0.0, width: getViewWidth(self.view), height: 200), collectionViewLayout: layout)
                    collectionView.backgroundColor = UIColor.orange
                    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
                    let tag = Int(i/ViewController.pageCount)
                    collectionView.tag = tag
                    return collectionView
                }()
                collectionView.delegate = self
                collectionView.dataSource = self
                self.scrollView.addSubview(collectionView)
            }
        }
        self.view.addSubview(self.pageController)
        self.pageController.numberOfPages = ViewController.tatalCount%8 == 0 ? ViewController.tatalCount/ViewController.pageCount : Int(ViewController.tatalCount/ViewController.pageCount) + 1
        self.pageController.addTarget(self, action: #selector(ViewController.setScrollViewContentOffSet), for: UIControlEvents.valueChanged)
        scrollView.contentSize = CGSize(width: CGFloat((Int(ViewController.tatalCount/8) + 1 ))*getViewWidth(self.view), height: 200)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.pageController.currentPage = Int(scrollView.contentOffset.x/getViewWidth(self.view))
    }
    
    @objc func setScrollViewContentOffSet(){
        self.scrollView .setContentOffset(CGPoint(x: CGFloat(self.pageController.currentPage) * getViewWidth(self.view), y: 0), animated: true)
    }
}


extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ViewController.tatalCount%ViewController.pageCount == 0 {
            return ViewController.pageCount
        }else{
            if (collectionView.tag < Int(ViewController.tatalCount/ViewController.pageCount)){
                return ViewController.pageCount
            }else{
                return (ViewController.tatalCount - Int(ViewController.tatalCount/ViewController.pageCount)*ViewController.pageCount)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }
}

