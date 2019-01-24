//
//  RxAlamofireCViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
class RxAlamofireCViewController: BaseViewController {
    let bag = DisposeBag()
     private let cellID = "cellid"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL.init(string: urlString)!

        let data: Observable<[Channel]> = requestJSON(.get, url).map{$1}.mapObject(type: Douban.self).map{ $0.channels ?? []}


        data.bind(to: self.tableView.rx.items) {
            tv, row, element in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID)!
            cell.textLabel?.text = element.name ?? ""
            return cell
        }.disposed(by: bag)
    }



}
