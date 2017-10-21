//
//  ViewController.swift
//  NameList
//
//  Created by 云松 on 2017/10/21.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class ViewController: UIViewController, UITableViewDelegate {
    
    lazy var tb: UITableView = UITableView().then{
        $0.backgroundColor = UIColor.clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    //数据源
    let items = Observable.just([
        SectionModel(model: "A", items: ["Aoe", "Alore", "Aflo"]),
        SectionModel(model: "C", items: ["Chrone", "Cc", "Come"]),
        SectionModel(model: "E", items: ["Eon", "Enk", "Eplp"]),
        SectionModel(model: "G", items: ["GG", "Go", "Google"]),
        SectionModel(model: "Z", items: ["Zone", "Zero", "Zzzz"])
        ])
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "NamesList"
        //初始化
        self.view.addSubview(self.tb)
        self.tb.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        //数据
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell:{
            (_, tb, indexpath, element) in
            let cell = tb.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = element
            return cell!
        })
        //标题,步骤1
        dataSource.titleForHeaderInSection = {dataSource, sectionIndex in
            return dataSource[sectionIndex].model}
        //索引
        dataSource.sectionIndexTitles = {dataSource -> [String]? in
            return dataSource.sectionModels.map({ $0.model})
        }
        //建立关系
        dataSource.sectionForSectionIndexTitle = {(dataSource, title , index) -> Int in return index
        }
        //绑定数据源 步骤2
        //ps:只能遇到必须把步骤一等初始化放在步骤二后面，这样有不会闪退
        //Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs
        self.items.bind(to: (self.tb.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
        //设置代理
        self.tb.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ViewController {
    //头的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}



