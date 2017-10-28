//
//  TableViewCell.swift
//  Demo_Three
//
//  Created by 云松 on 2017/10/28.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var labTitle: UILabel!
    @IBOutlet weak var labTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.layer.cornerRadius = self.img.frame.size.width/2
        self.img.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
