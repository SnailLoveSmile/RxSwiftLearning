//
//  RxMoyaJsonViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class RxMoyaJsonViewController: BaseViewController {
    let bag = DisposeBag()
    private let cellID = "cellID"
     @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        let data = DouBanProvider.rx.request(.channels)
            .mapJSON()
            .map{ data -> [[String: Any]] in
                if let json = data as? [String: Any], let channels = json["channels"] as? [[String: Any]]{
                    return channels
                } else {
                    return []
                }
            }.asObservable()

        data.bind(to: tableView.rx.items){ tb, row, element in
            let cell = tb.dequeueReusableCell(withIdentifier: self.cellID)!
            cell.textLabel?.text = "\(element["name"]!)"
            return cell
            }.disposed(by: bag)


    }
}
