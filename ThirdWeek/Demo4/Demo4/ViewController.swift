//
//  ViewController.swift
//  Demo4
//
//  Created by 云松 on 2017/11/4.
//  Copyright © 2017年 kwl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tb: UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    private let cellIndentify = "Cell"
    let list = ["🐲", "🦀️", "🐍", "🐟", "🐢", "🐸",]
    var reloadTitle: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTitle = self.list.first
        
        self.title = "联动"
        
        self.tb.delegate = self
        self.tb.dataSource = self
        self.tb.tableFooterView = UIView()
        self.tb .register(UITableViewCell.self, forCellReuseIdentifier: cellIndentify)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 30 - 80)/2, height: (self.view.frame.size.width - 30)/2)
        layout.scrollDirection = .vertical
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIndentify)
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIndentify)
        cell?.textLabel?.text = self.list[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadTitle = list[indexPath.row]
        self.collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentify, for: indexPath)
        let lab = { () -> UILabel in
            let lab = UILabel(frame: cell.bounds)
            let R = CGFloat(arc4random() % 256)
            let G = CGFloat(arc4random() % 256)
            let B = CGFloat(arc4random() % 256)
            lab.backgroundColor = UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
            lab.textColor = UIColor.white
            lab.font = UIFont.systemFont(ofSize: 22)
            lab.textAlignment = NSTextAlignment.center
            return lab
        }()
        lab.text = "我是" + reloadTitle!
        cell.backgroundView = lab
        return cell
    }
}
