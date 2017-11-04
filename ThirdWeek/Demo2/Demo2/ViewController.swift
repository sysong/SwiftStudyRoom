//
//  ViewController.swift
//  Demo2
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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let totalCount : Int = 100
    
    let space: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = { () -> UICollectionViewFlowLayout in
            let lay = UICollectionViewFlowLayout()
            let height = (getViewWidth(self.view) - 3 * self.space)/2
            lay.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
            lay.itemSize = CGSize(width: height, height: height)
            return lay
        }()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let R = CGFloat(arc4random() % 256)
        let G = CGFloat(arc4random() % 256)
        let B = CGFloat(arc4random() % 256)
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
         cell.backgroundColor = UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
        cell.layer.cornerRadius = 5.0
        cell.layer.masksToBounds = true
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

