//
//  CollectionViewCell.swift
//  Demo3
//
//  Created by 云松 on 2017/11/4.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lab: UILabel!
    
    override func awakeFromNib() {
        let R = CGFloat(arc4random() % 256)
        let G = CGFloat(arc4random() % 256)
        let B = CGFloat(arc4random() % 256)
        self.backgroundColor = UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
        self.lab.layer.cornerRadius = 15.0
        self.lab.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        super.awakeFromNib()
        // Initialization code
    }

}
