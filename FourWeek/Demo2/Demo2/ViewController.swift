//
//  ViewController.swift
//  Demo2
//
//  Created by 云松 on 2017/11/7.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit


let kScreen = UIScreen.main.bounds.size.width

class ViewController: UIViewController, CAAnimationDelegate {

    lazy var labLeft = { () -> UILabel in
        let lab = UILabel(frame: CGRect(x: 50.0, y: 100.0, width: 100, height: 100))
        lab.backgroundColor = UIColor.orange
        return lab
    }()
    
    lazy var labRight = { () -> UILabel in
        let lab = UILabel(frame: CGRect(x: kScreen - 100 - 50.0, y: 100.0, width: 100, height: 100))
        lab.backgroundColor = UIColor.yellow
        return lab
    }()
    
    lazy var labBottom = { () -> UILabel in
        let lab = UILabel(frame: CGRect(x: 100, y: 300, width: kScreen - 200, height: 30))
        lab.backgroundColor = UIColor.lightGray
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.labLeft)
        self.view.addSubview(self.labRight)
        self.view.addSubview(self.labBottom)
        
        self.perform(#selector(addAnimation), with: nil, afterDelay: 1.0)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func addAnimation() {
        
        let leftCf = CAKeyframeAnimation(keyPath: "position")
        let position = labLeft.center
        let value1 = NSValue.init(cgPoint: labLeft.center)
        let value2 = NSValue.init(cgPoint: CGPoint(x: labLeft.center.x + 30, y: labLeft.center.y + 30))
        let value3 = NSValue.init(cgPoint: CGPoint(x: position.x, y: position.y + 60))
        leftCf.delegate = self
        leftCf.values = [value1, value2, value3]
        leftCf.isRemovedOnCompletion = false
        leftCf.fillMode = kCAFillModeForwards
        leftCf.duration = 1.0
        leftCf.calculationMode = kCAAnimationCubicPaced
        labLeft.layer.add(leftCf, forKey: "leftCf")
        
        let rightCf = CAKeyframeAnimation(keyPath: "position")
        let rposition = labRight.center
        let r1 = NSValue.init(cgPoint: labRight.center)
        let r2 = NSValue.init(cgPoint: CGPoint(x: labRight.center.x + 30, y: labRight.center.y + 30))
        let r3 = NSValue.init(cgPoint: CGPoint(x: rposition.x, y: rposition.y + 60))
        rightCf.delegate = self
        rightCf.values = [r1, r2, r3]
        rightCf.isRemovedOnCompletion = false
        rightCf.fillMode = kCAFillModeForwards
        rightCf.calculationMode = kCAAnimationCubicPaced
        rightCf.duration = 1.0
        labRight.layer.add(rightCf, forKey: "rightCf")
        
        //组合
        let bottomCf = CABasicAnimation(keyPath: "position.y")
        bottomCf.fromValue = labBottom.center.y
        bottomCf.toValue = labBottom.center.y + 60
        bottomCf.isRemovedOnCompletion = false
        bottomCf.fillMode = kCAFillModeForwards
        
        let bottomFrameCf = CABasicAnimation(keyPath: "bounds")
        bottomFrameCf.toValue = NSValue.init(cgRect: CGRect(x: labBottom.frame.origin.x, y: labBottom.frame.origin.y, width: labBottom.frame.size.width, height: labBottom.frame.size.height + 50))
        
        let group = CAAnimationGroup()
        group.isRemovedOnCompletion = false
        group.duration = 1.0
        group.fillMode = kCAFillModeForwards
        group.animations = [bottomFrameCf, bottomCf]
        
        labBottom.layer.add(group, forKey: "group")
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
           labRight.backgroundColor = UIColor.orange
           labLeft.backgroundColor = UIColor.yellow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

