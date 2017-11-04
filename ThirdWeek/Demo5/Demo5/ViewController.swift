//
//  ViewController.swift
//  Demo5
//
//  Created by 云松 on 2017/11/5.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var col: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let lay = UICollectionViewFlowLayout()
        lay.itemSize = CGSize(width: (self.view.frame.size.width - 30)/2, height: (self.view.frame.size.width - 30)/2)
        self.col.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.col.setCollectionViewLayout(lay, animated: true)
        self.col.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
         cell.btn.setImage(UIImage(named: "\(indexPath.row+1).jpg"), for: .normal)
         cell.btn.tag = indexPath.row
         cell.btn.addTarget(self, action: #selector(click), for: .touchUpInside)
         return cell
    }
    
    var lastFrame: CGRect = CGRect.zero
    var img: UIImageView? = nil
    @objc func click(btn:UIButton) {
        let index = IndexPath(row: btn.tag, section: 0)
        let cell = self.col.cellForItem(at: index) as! CollectionViewCell
        //添加遮盖
        let cover = UIView(frame:UIScreen.main.bounds)
        cover.backgroundColor = UIColor.white
        cover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dissCell(tap:))))
        UIApplication.shared.keyWindow?.addSubview(cover)
        //添加图片
        let img = UIImageView(image: UIImage(named: "\(btn.tag + 1).jpg"))
        img.frame = cover.convert(cell.btn.frame, from: cell)
        lastFrame = img.frame
        cover.addSubview(img)
        self.img = img
        //动画
        UIView.animate(withDuration: 0.3) {
           var frame = img.frame
            frame.size.width = cover.frame.size.width
            frame.size.height = cover.frame.size.width * ((img.image?.size.height)! / (img.image?.size.width)!);
            frame.origin.x = 0;
            frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.5;
            img.frame = frame;
        }
    }
    
    @objc func dissCell(tap:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
           tap.view?.backgroundColor = UIColor.clear
            self.img?.frame = self.lastFrame
        }) { finish in
            tap.view?.removeFromSuperview()
            self.img = nil
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

