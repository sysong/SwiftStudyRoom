//
//  ViewController.swift
//  TipCalculator
//
//  Created by 云松 on 2017/10/21.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ViewController: UIViewController {
    //输入框
    lazy var tx: UITextField = UITextField().then{
        $0.placeholder = "$0.00"
        $0.font = UIFont.systemFont(ofSize: 40)
        $0.clearsOnBeginEditing = true
        $0.clearButtonMode = .whileEditing
        $0.textAlignment = NSTextAlignment.right
        $0.keyboardType = UIKeyboardType.numberPad
    }
    //第一排的tip控件
    lazy var labTip: UILabel = UILabel().then{
        $0.textAlignment = NSTextAlignment.right
        $0.text = "Tip(%15)"
        $0.textColor = UIColor.black
    }
    //第一排价格的控件
    lazy var labTipMoney: UILabel = UILabel().then{
        $0.textAlignment = NSTextAlignment.left
        $0.text = "0.00"
        $0.textColor = UIColor.black
    }
    //总价
    lazy var labTotalMoney: UILabel = UILabel().then{
        $0.textAlignment = NSTextAlignment.left
        $0.text = "0.00"
        $0.textColor = UIColor.black
    }
    //滑动
    lazy var silder: UISlider = UISlider().then{
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.setValue(15, animated: true)
        $0.tintColor = UIColor.blue
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //标题
        self.navigationItem.title = "Tip Calculator"
        //输入框
        self.view.addSubview(self.tx)
        self.tx.snp.makeConstraints({ make in
            make.top.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(100)
        })
        //第一排的tip控件
        self.view.addSubview(self.labTip)
        self.labTip.snp.makeConstraints({ make in
            make.top.equalTo(self.tx.snp.bottom).offset(50)
            make.left.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(UIScreen.main.bounds.size.width/2 - 20)
        })
        //第一排价格的控件
        self.view.addSubview(self.labTipMoney)
        self.labTipMoney.snp.makeConstraints({ make in
            make.top.equalTo(self.labTip.snp.top)
            make.bottom.equalTo(self.labTip.snp.bottom)
            make.left.equalTo(self.labTip.snp.right).offset(40)
            make.right.equalTo(self.view.snp.right)
        })
        
        //第二排的总数
        _ = UILabel().then{
            self.view.addSubview($0)
            $0.textAlignment = NSTextAlignment.right
            $0.text = "Total"
            // $0.backgroundColor = UIColor.red
            $0.textColor = UIColor.black
            $0.snp.makeConstraints({ make in
                make.top.equalTo(self.labTip.snp.bottom).offset(30)
                make.trailing.equalTo(self.labTip.snp.trailing)
                make.leading.equalTo(self.labTip.snp.leading)
                make.height.equalTo(self.labTip.snp.height)
            })
        }
        
        //第二排的总数价格
        self.view.addSubview(self.labTotalMoney)
        self.labTotalMoney.snp.makeConstraints({ make in
            make.top.equalTo(self.labTipMoney.snp.bottom).offset(30)
            make.trailing.equalTo(self.labTipMoney.snp.trailing)
            make.leading.equalTo(self.labTipMoney.snp.leading)
            make.height.equalTo(self.labTipMoney.snp.height)
        })
        
        //滑动条
        self.view.addSubview(self.silder)
        self.silder.snp.makeConstraints({ make in
            make.top.equalTo(self.labTotalMoney.snp.bottom).offset(30)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.height.equalTo(30)
        })
        
        
        //点击的操作
        let tap = UITapGestureRecognizer()
        tap.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        view.addGestureRecognizer(tap)
        
        //滑动的动作操作
        self.silder.rx.value.subscribe(onNext: { value in
            self.caculate(slideValue: value)
        })
            .disposed(by: disposeBag)
        
        //输入的时候操作
        self.tx.rx.value.subscribe({ text in
            self.caculate(slideValue: self.silder.value)
        })
            .disposed(by: disposeBag)
        
        // Do any additional setup after loading the view.
    }
    
    
    func caculate(slideValue: Float?){
        guard !(self.tx.text?.isEmpty)!, slideValue != 0, slideValue! > Float(15.0) else {
            self.labTip.text = "Tip(15%)"
            self.labTotalMoney.text = "0.00"
            self.labTipMoney.text = "0.00"
            return
        }
        let price = String(format: "%.2f", slideValue!)
        self.labTip.text = "Tip(\(price)%)"
        let tip = (slideValue!/100) * Float((self.tx.text)!)!
        self.labTipMoney.text = String(format: "%.2f", tip)
        self.labTotalMoney.text = String(format: "%.2f", tip + Float((self.tx.text)!)!)
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
