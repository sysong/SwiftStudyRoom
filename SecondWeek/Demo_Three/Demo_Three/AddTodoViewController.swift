//
//  AddTodoViewController.swift
//  Demo_Three
//
//  Created by 云松 on 2017/10/28.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
//回调
typealias AddTodoBlock = (_ todo: Todo) -> Void;

class AddTodoViewController: UIViewController {
    
    var addTodoBlock: AddTodoBlock? = nil
    private static let bag = DisposeBag()
    @IBOutlet weak var btnAir: UIButton!
    @IBOutlet weak var btnMobile: UIButton!
    @IBOutlet weak var btnShopping: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var tx: UITextField!
    var btnRecord: UIButton? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "New ToDo"
        //这边应该还有几种关联关系
        
        btnAir.rx.tap.subscribe { [weak self] _ in
            self?.btnAir.isSelected = true
            self?.btnRecord?.isSelected = false
            self?.btnRecord = self?.btnAir
        }.disposed(by: AddTodoViewController.bag)
        
        btnMobile.rx.tap.subscribe { [weak self] _ in
            self?.btnMobile.isSelected = true
            self?.btnRecord?.isSelected = false
            self?.btnRecord = self?.btnMobile
        }.disposed(by: AddTodoViewController.bag)
        
        btnShopping.rx.tap.subscribe { [weak self] _ in
            self?.btnShopping.isSelected = true
            self?.btnRecord?.isSelected = false
            self?.btnRecord = self?.btnShopping
        }.disposed(by: AddTodoViewController.bag)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneEvent(_ sender: Any) {
        //这个应该用obserable链接的。。怎么弄？
        if self.btnRecord?.isSelected == false || self.tx.text?.characters.count == 0 || self.btnRecord == nil{
            return
        }
        //处理时间
        let date: Date = self.datePickerView.date
        let dff = DateFormatter()
        dff.dateFormat = "yyyy-MM-dd"
        let datestr: String = dff.string(from: date)
        //
        let todo = Todo(tag: Int(arc4random()%1000000), todoType: TodoType(rawValue: (self.btnRecord?.tag)!)!, title: self.tx.text, date: datestr)
        guard let addTodoBlock = self.addTodoBlock else{
            return
        }
        addTodoBlock(todo)
        self.navigationController?.popViewController(animated: true)
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
