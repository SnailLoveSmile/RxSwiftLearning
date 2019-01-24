//
//  RxAlamofireJsonViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/20.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
class RxAlamofireJsonViewController: BaseViewController {
    let bag = DisposeBag()
   private let cellID = "cellid"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

       let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL.init(string: urlString)!
        let data = requestJSON(.get, url).map { (respons, data) -> [[String: Any]] in

            guard let json = data as? [String: Any],
                let channels  = json["channels"] as? [[String: Any]]
                else {
                    return []
            }
            return channels
        }

        data.bind(to: self.tableView.rx.items){ tv, row, element in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID)!
            cell.textLabel?.text = "\(row): \(element["name"] ?? "")"
            return cell
        }.disposed(by: bag)

    }
}
