//
//  ViewController.swift
//  Demo1
//
//  Created by 云松 on 2017/11/6.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

func getClockWidth(_ view: UIView) -> CGFloat {
    return view.frame.size.width
}

class ViewController: UIViewController {
    @IBOutlet weak var img: UIImageView!
    //时钟
    lazy var hLayer = { () -> CALayer in
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.position = CGPoint(x: getClockWidth(img)*0.5, y: getClockWidth(img)*0.5)
        layer.bounds = CGRect(x: 0, y: 0, width: 4, height: getClockWidth(img)*0.5 - 30)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        return layer
    }()
    //分钟
    lazy var mLayer = { () -> CALayer in
        let layer = CALayer()
        layer.backgroundColor = UIColor.red.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.position = CGPoint(x: getClockWidth(img)*0.5, y: getClockWidth(img)*0.5)
        layer.bounds = CGRect(x: 0, y: 0, width: 4, height: getClockWidth(img)*0.5 - 20)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        return layer
    }()
    //秒针
    lazy var sLayer = { () -> CALayer in
        let layer = CALayer()
        layer.backgroundColor = UIColor.orange.cgColor
        layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        layer.position = CGPoint(x: getClockWidth(img)*0.5, y: getClockWidth(img)*0.5)
        layer.bounds = CGRect(x: 0, y: 0, width: 2, height: getClockWidth(img)*0.5 - 10)
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.img.layer.addSublayer(hLayer)
        self.img.layer.addSublayer(mLayer)
        self.img.layer.addSublayer(sLayer)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(printtt), userInfo: nil, repeats: true)
        
        //dispathch定时器
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler(handler: {
            print("....")
            //获取当前的时间
            let calender = NSCalendar.current
            let cmp = calender.dateComponents([Calendar.Component.second, Calendar.Component.minute, Calendar.Component.hour], from: Date())
            //弧度
            let m = CGFloat(cmp.minute ?? 0)
            let mR = CGFloat(m * 6 / 180) * CGFloat(Double.pi)
            
            let s = CGFloat(cmp.second ?? 0)
            let sR = CGFloat(s * 6 / 180) * CGFloat(Double.pi)
            
            let h = CGFloat(cmp.hour ?? 0)
            let hR = CGFloat((h * 30 + m * 0.5) / 180) * CGFloat(Double.pi)
            
            
            self.hLayer.transform = CATransform3DMakeRotation(hR, 0, 0, 1)
            self.mLayer.transform = CATransform3DMakeRotation(mR, 0, 0, 1)
            self.sLayer.transform = CATransform3DMakeRotation(sR, 0, 0, 1)
        })
        timer.resume()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func printtt(){
        let calender = NSCalendar.current
        let cmp = calender.dateComponents([Calendar.Component.second, Calendar.Component.hour, Calendar.Component.minute], from: Date())
        //弧度
        let m = CGFloat(cmp.minute ?? 0)
        let mR = CGFloat(m * 6 / 180) * CGFloat(Double.pi)
        
        let s = CGFloat(cmp.second ?? 0)
        let sR = CGFloat(s * 6 / 180) * CGFloat(Double.pi)
        
        let h = CGFloat(cmp.hour ?? 0)
        let hR = CGFloat((h * 30 + m * 0.5) / 180) * CGFloat(Double.pi)
        
        
        self.hLayer.transform = CATransform3DMakeRotation(hR, 0, 0, 1)
        self.mLayer.transform = CATransform3DMakeRotation(mR, 0, 0, 1)
        self.sLayer.transform = CATransform3DMakeRotation(sR, 0, 0, 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

