//
//  ViewController.swift
//  Demo_Four
//
//  Created by 云松 on 2017/10/28.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol LXFViewModeType {
     associatedtype Input
     associatedtype OutPut
     func transform(input: Input) -> OutPut
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tb: UITableView!
    private static let Indentify = "TableViewCell"
    private static let bag = DisposeBag()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tb.tableFooterView = UIView()
        self.tb.register(TableViewCell.self, forCellReuseIdentifier: ViewController.Indentify)
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        items.bind(to: tb.rx.items(cellIdentifier: ViewController.Indentify, cellType: TableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element)........"
            cell.delegate = self
            cell.rightButtons = [MGSwipeButton(title: "Share", icon: UIImage(named:"check.png"), backgroundColor: .green),
                                 MGSwipeButton(title: "Done", icon: UIImage(named:"fav.png"), backgroundColor: .blue),
                                 MGSwipeButton(title: "Delete", backgroundColor: .red)]
            cell.rightSwipeSettings.transition = .rotate3D
            }.disposed(by: ViewController.bag)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        let alertController = UIAlertController(title: nil, message: "点击\(index)个", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return true
    }
}

