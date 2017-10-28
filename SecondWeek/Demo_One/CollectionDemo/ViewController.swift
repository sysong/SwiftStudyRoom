//
//  ViewController.swift
//  CollectionDemo
//
//  Created by 云松 on 2017/10/23.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import Then

struct Person {
    var img: String? = ""
    var name :  String? = ""
    var mobile: String? = ""
    var email:  String? = ""
    var notes:  String? = ""
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tb: UITableView!
    
    fileprivate static let cellIndentify: String = "cell"
    
    fileprivate static let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contact"
        //加载数据
        var listData = Array<Array<Person>>()
        let tempList = self.dealAnyPlistData(plistName: "PhoneList")
        tempList.forEach { item in
            var rowList = Array<Person>()
            let itemList: Array = item as! Array<AnyObject>
            itemList.forEach{ dict in
                let tempDict : Dictionary = dict as! Dictionary<String, String>
                let p = Person(img: tempDict["img"], name: tempDict["name"], mobile: tempDict["mobile"], email: tempDict["email"], notes: tempDict["notes"])
                rowList.append(p)
            }
            listData.append(rowList)
        }
        //转变对应的sectionmodel
        let Items = Variable(Array<SectionModel<String, Person>>())
        var ItemsValue = Array<SectionModel<String, Person>>()
        listData.forEach { list in
            let section = SectionModel(model: "\(list.count)", items: list)
            ItemsValue.append(section)
        }
        Items.value = ItemsValue
        
        //先注册
        tb.register(UITableViewCell.self, forCellReuseIdentifier: ViewController.cellIndentify)
        //绑定数据源
        let dataSoruce = RxTableViewSectionedReloadDataSource<SectionModel<String, Person>>(configureCell:{
            (_, tb, indexPath, element) in
            let cell = tb.dequeueReusableCell(withIdentifier: ViewController.cellIndentify)!
            cell.textLabel?.text = element.name
            cell.accessoryType = .disclosureIndicator
            return cell
        })
        
        dataSoruce.titleForHeaderInSection = { dataSoruce, sectionIndex in
            return dataSoruce[sectionIndex].model
        }
        
        Items.asObservable().bind(to: self.tb.rx.items(dataSource: dataSoruce)).disposed(by: ViewController.bag)
        
        //选择事件
        self.tb.rx.itemSelected
            .map { indexPath in
                return (indexPath, dataSoruce[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                 let cInfoVC = ContactInfo()
                 cInfoVC.p = model
                 self.navigationController?.pushViewController(cInfoVC, animated: true)
            })
            .disposed(by: ViewController.bag)
        
        //左边的item
        let _ = UIButton().then {
            $0.setImage(UIImage.init(named: "set"), for: UIControlState.normal)
            //$0.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
            $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: $0)
        }
        
        let _ = UIButton().then {
            $0.setImage(UIImage.init(named: "add"), for: UIControlState.normal)
            //$0.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
            $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: $0)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func dealAnyPlistData(plistName:String) -> Array<Any> {
        
        let path:String? = Bundle.main.path(forResource: plistName, ofType: "plist")
        guard let listPath = path else {
            return []
        }
        let plistArray:NSArray? = NSArray(contentsOfFile: listPath)
        //如果为空，直接pass
        guard let dataList = plistArray , dataList.count > 0 else {
            return []
        }
        return plistArray as! Array<Any>;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

