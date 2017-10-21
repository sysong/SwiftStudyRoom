//
//  ViewController.swift
//  CityList
//
//  Created by 云松 on 2017/10/21.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

//用到的demo
class CityListModel: NSObject {
    var firstIndex: Int = 0
    var secondIndex: Int = 0
    var thirdIndex: Int = 0
    var isOpen: Bool = false
    var isShow: Bool = false
    var title: String = ""
    
    init(first:Int, second:Int, third: Int, isOpen: Bool, isShow: Bool, title: String) {
        super.init()
        self.firstIndex = first
        self.secondIndex = second
        self.thirdIndex = third
        self.isOpen = isOpen
        self.isShow = isShow
        self.title = title
    }
}

class ViewController: UIViewController, UITableViewDelegate {
    //tableView
    var tb: UITableView? = nil
    let disposeBag = DisposeBag()
    var dataSource = [
        CityListModel.init(first: 1, second: 0, third: 0, isOpen: true, isShow: true, title: "亚洲"),
        CityListModel.init(first: 1, second: 1, third: 0, isOpen: false, isShow: true, title: "中国"),
        CityListModel.init(first: 1, second: 1, third: 1, isOpen: false,isShow: false, title: "深圳"),
        CityListModel.init(first: 1, second: 1, third: 2, isOpen: false,isShow: false, title: "合肥"),
        CityListModel.init(first: 1, second: 2, third: 0, isOpen: false,isShow: true, title: "俄罗斯"),
        CityListModel.init(first: 1, second: 2, third: 1, isOpen: false,isShow: false, title: "莫斯科"),
        CityListModel.init(first: 1, second: 2, third: 2,isOpen: false, isShow: false, title: "莫达利亚"),
        CityListModel.init(first: 2, second: 0, third: 0, isOpen: true,isShow: true, title: "南美洲"),
        CityListModel.init(first: 2, second: 1, third: 0,isOpen: false, isShow: true, title: "巴西"),
        CityListModel.init(first: 2, second: 2, third: 0, isOpen: false,isShow: true, title: "阿根廷"),
        CityListModel.init(first: 3, second: 0, third: 0, isOpen: true,isShow: true, title: "澳洲"),
        CityListModel.init(first: 3, second: 1, third: 0, isOpen: false,isShow: true, title: "澳大利亚"),
        CityListModel.init(first: 3, second: 2, third: 0, isOpen: false,isShow: true, title: "新西兰")
    ]
    //
    fileprivate static let indentify = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tb = UITableView().then{
            self.view.addSubview($0)
            $0.snp.makeConstraints({ make in
                make.edges.equalTo(self.view)
            })
            $0.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.indentify)
            $0.separatorStyle = .none
        }
        
        let items = Variable([CityListModel]())
        items.value = dataSource
        items.asObservable().bind(to: (tb?.rx.items(cellIdentifier: ViewController.indentify, cellType: UITableViewCell.self))!){
            (row, element, cell) in
            guard element.isShow else {
                cell.textLabel?.text = ""
                cell.backgroundColor = UIColor.white
                return
            }
            guard element.firstIndex > 0 else {
                return
            }
            cell.textLabel?.text = "\(element.title)"
            cell.backgroundColor = UIColor.gray
            guard element.secondIndex > 0 else {
                return
            }
            cell.textLabel?.text = "     \(element.title)"
            cell.backgroundColor = UIColor.lightGray
            guard element.thirdIndex > 0 else {
                return
            }
            cell.textLabel?.text = "           \(element.title)"
            cell.backgroundColor = UIColor.white
            }.disposed(by: disposeBag)
        
        tb?.rx.modelSelected(CityListModel.self)
            .subscribe(onNext: { value in
                //删除？处理数据？
                //点击第一级，同时收回第二级和第三极
                guard value.firstIndex > 0 , value.secondIndex == 0, value.thirdIndex == 0 else {
                    //点击第二级，同时把第三级收回
                    guard value.secondIndex > 0, value.firstIndex > 0 else {
                        return
                    }
                    //点击第三极不做任何处理
                    guard value.thirdIndex == 0, value.firstIndex > 0, value.secondIndex > 0 else {
                        return
                    }
                    value.isOpen = !value.isOpen
                    self.dataSource.forEach({ model in
                        if model.secondIndex == value.secondIndex && model.thirdIndex != 0 && model.firstIndex == value.firstIndex {
                            model.isShow = value.isOpen
                        }
                    })
                    items.value = self.dataSource
                    return
                }
                value.isOpen = !value.isOpen
                self.dataSource.forEach({ model in
                    if model.firstIndex == value.firstIndex && model.secondIndex != 0 {
                        model.isShow = value.isOpen
                        model.isOpen = value.isOpen
                    }
                })
                items.value = self.dataSource
            }).disposed(by: disposeBag)
        
        tb?.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let exercise = dataSource[indexPath.row]
        if exercise.isShow {
            return 40;
        }else{
            return 0.00
        }
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
