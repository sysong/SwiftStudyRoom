//
//  ViewController.swift
//  StopWatch
//
//  Created by 云松 on 2017/10/21.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import Then
import RxCocoa
import RxSwift
import SnapKit


class ViewController: UIViewController {
    
    let bag = DisposeBag()
    var timer: Observable<Int>!
    var labCount: UILabel? = nil
    var isRetting: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "定时器"
        
        self.labCount = UILabel().then{
            self.view.addSubview($0)
            $0.backgroundColor = UIColor.black
            $0.textAlignment = NSTextAlignment.center
            $0.text = "0.0"
            $0.textColor = UIColor.white
            $0.font = UIFont.systemFont(ofSize: 60.0)
            $0.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 1/2*UIScreen.main.bounds.size.height, 0))
            })
        }
        
        let btnStart = UIButton().then{
            self.view.addSubview($0)
            $0.setTitle("start", for: UIControlState.normal)
            $0.backgroundColor = UIColor.blue
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 40)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(self.labCount!.snp.bottom)
                make.left.equalTo(self.view.snp.left)
                make.bottom.equalTo(self.view.snp.bottom)
                make.width.equalTo(UIScreen.main.bounds.size.width/2)
            })
        }
        
        let btnStop = UIButton().then{
            self.view.addSubview($0)
            $0.setTitle("stop", for: UIControlState.normal)
            $0.backgroundColor = UIColor.green
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 40)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(self.labCount!.snp.bottom)
                make.right.equalTo(self.view.snp.right)
                make.bottom.equalTo(self.view.snp.bottom)
                make.left.equalTo(btnStart.snp.right)
            })
        }
        
        //reset
        let btnReset = UIButton().then{
            self.view.addSubview($0)
            $0.setTitle("reset", for: UIControlState.normal)
            $0.setTitleColor(UIColor.white, for: UIControlState.normal)
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(self.view.snp.top).offset(10)
                make.right.equalTo(self.view.snp.right).offset(-15)
                make.width.equalTo(100)
                make.height.equalTo(50)
            })
        }
        
        let isRunning = Observable
            .merge([btnStart.rx.tap.map({ return true }), btnStop.rx.tap.map({ return false }),  btnReset.rx.tap.map({ return false })])
            .startWith(false)
            .share(replay: 1)
        
        let isntRunning = isRunning
            .map{!$0}
            .share(replay: 1)
        
        isRunning
            .bind(to: btnStop.rx.isEnabled)
            .disposed(by: bag)
        
        isntRunning
            .bind(to: btnStart.rx.isEnabled)
            .disposed(by: bag)
        
        enum TestError: Swift.Error {
            case test
        }
        
        //点击暂停了，序列保持不变，跑出异常处理？
        timer = Observable<Int>
            .interval(0.1, scheduler: MainScheduler.instance)
            .filter({_ in
                if self.isRetting {throw TestError.test} else {
                    return true
                }})
            .withLatestFrom(isRunning, resultSelector: {_, running in running})
            .filter({running in running})
            .scan(0, accumulator: {(acc, _) in
                return acc + 1
            })
            .startWith(0)
            .retry()
            .share(replay: 1)
  
        timer.map{self.stringValue(value:$0)}
            .bind(to: self.labCount!.rx.text)
            .disposed(by: bag)
        
        btnReset.rx.tap.subscribe { _ in
            self.isRetting = true
            }.disposed(by: bag)
        
        btnStop.rx.tap.subscribe { _ in
            self.isRetting = false
            }.disposed(by: bag)
        
        btnStart.rx.tap.subscribe { _ in
            self.isRetting = false
            }.disposed(by: bag)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func stringValue(value: Int) -> String {
        return String(format:"%.1f", Float(value)/10)
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

