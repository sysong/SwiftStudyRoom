//
//  ViewController.swift
//  Demo_Three
//
//  Created by 云松 on 2017/10/28.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Then
import SnapKit


enum TodoType: Int {
    case Air = 0, Mobile, Shopping
}

extension ViewController {
    func imgUrl(type:TodoType) -> String {
        switch type {
        case .Air: return "air_selected"
        case .Mobile: return "mobile_selected"
        case .Shopping: return "shopping_selected"
        }
    }
}

struct Todo {
    var tag: Int = 0
    var todoType: TodoType
    var title: String? = nil
    var date: String? = nil
}


class ViewController: UIViewController {

    private static let bag = DisposeBag()
    private static let indentify: String = "TableViewCell"
    var todoList: Array = Array<Todo>()
    var items = Variable([Todo]())
    @IBOutlet weak var tb: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo List"
        self.tb.register(UINib.init(nibName: ViewController.indentify, bundle: nil), forCellReuseIdentifier: ViewController.indentify)
        self.tb.tableFooterView = UIView()
        
        self.createRightItem()
        self.createLeftItem();
        //绑定数据
        items.asObservable().bind(to:tb.rx.items(cellIdentifier: ViewController.indentify, cellType: TableViewCell.self)){
            (row, element, cell) in
             cell.img.image = UIImage.init(named:self.imgUrl(type: element.todoType))
             cell.labTitle.text = element.title
             cell.labTime.text = element.date
        } .disposed(by: ViewController.bag)
        
        self.items.value = self.todoList
        //设置代理
        self.tb.rx.setDelegate(self).disposed(by: ViewController.bag)
        //删除操作
        self.tb.rx.itemDeleted.map{
            indexpath in return self.todoList[indexpath.row]
            }.subscribe { todo in
                var i = -1
                for (index, value) in self.todoList.enumerated() {
                    if value.tag == todo.element?.tag {
                        i = index
                    }
                }
                guard i >= 0 else {
                    return
                }
                self.todoList.remove(at: i)
                self.items.value = self.todoList
        }.disposed(by: ViewController.bag)
        //移动
        self.tb.rx.itemMoved.subscribe { (event) in
            let sourceIndexPath = (event.element?.sourceIndex)!
            let destinationIndexPath = (event.element?.destinationIndex)!
            if sourceIndexPath != destinationIndexPath{
                let itemValue:Todo = self.todoList[sourceIndexPath.row]
                self.todoList.remove(at: sourceIndexPath.row)
                if destinationIndexPath.row > self.todoList.count{
                    self.todoList.append(itemValue)
                }else{
                    self.todoList.insert(itemValue, at:destinationIndexPath.row)
                }
                self.items.value = self.todoList
            }
        }.disposed(by: ViewController.bag)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //左边按钮
    func createLeftItem() {
        let btnRightItem = UIButton().then{
            $0.setTitle("Edit", for: UIControlState.normal)
            $0.setTitleColor(UIColor.blue, for: UIControlState.normal)
            $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            $0.isSelected = false
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: $0)
        }
        btnRightItem.rx.tap.subscribe { [weak self] _ in
            btnRightItem.isSelected = !btnRightItem.isSelected
            self?.tb.isEditing = btnRightItem.isSelected
            let title = btnRightItem.isSelected ? "Done": "Edit"
            btnRightItem.setTitle(title, for: UIControlState.normal)
        }.disposed(by: ViewController.bag)
    }
    
    //右边添加按钮
    func createRightItem() {
        let btnRightItem = UIButton().then{
            $0.setTitle("+", for: UIControlState.normal)
            $0.setTitleColor(UIColor.blue, for: UIControlState.normal)
            $0.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: $0)
        }
        
        btnRightItem.rx.tap.subscribe { [weak self] _ in
            let addVC = AddTodoViewController()
            addVC.addTodoBlock = { [weak self] todo in
                self?.todoList.append(todo)
                self?.items.value = (self?.todoList)!
            }
            self?.navigationController?.pushViewController(addVC, animated: true)
            }.disposed(by: ViewController.bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    //在编辑状态，可以拖动设置cell位置
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
