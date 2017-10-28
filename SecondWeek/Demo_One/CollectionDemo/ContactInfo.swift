//
//  ContactInfo.swift
//  CollectionDemo
//
//  Created by 云松 on 2017/10/27.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

class ContactInfo: UIViewController {
    
    public var p: Person? = nil //传递数据
    
    @IBOutlet weak var img: UIImageView! //头像
    
    @IBOutlet weak var labName: UILabel! //名字
    
    @IBOutlet weak var labPhone: UILabel! //电话
    
    @IBOutlet weak var labEmail: UILabel! //email
    
    @IBOutlet weak var labNotes: UILabel! //笔记
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Card Info"
        
        self.img.layer.cornerRadius = self.img.frame.size.width/2;
        self.img.layer.masksToBounds = true
        self.img.layer.borderColor = UIColor.lightGray.cgColor
        self.img.layer.borderWidth = 1.0
        
        self.labName.text = p?.name
        self.labEmail.text = p?.email
        self.labNotes.text = p?.notes
        self.labPhone.text = p?.mobile
        //照片
        let path = Bundle.main.path(forResource:p?.img, ofType: "jpg")
        guard let imgPath = path else {
            return
        }
        let data = try? Data(contentsOf: URL(fileURLWithPath: imgPath))
        self.img.image = UIImage.init(data: data!)
        
        let _ = UIButton().then {
            $0.setTitle("Edit", for: UIControlState.normal)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
            $0.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
            $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: $0)
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
