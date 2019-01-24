//
//  RxMoyaCViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
class RxMoyaCViewController: BaseViewController {
    let bag = DisposeBag()
    private let cellID = "cellID"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        let data: Observable<[ListItemModel]> = DouBanProvider.rx.request(.channels)
            .asObservable()
            .mapModel(T: ListModel.self)
            .map{ $0.channels ?? [] }

        data.bind(to: self.tableView.rx.items){
            (tb, row, element) in

            let cell = tb.dequeueReusableCell(withIdentifier: self.cellID)!
            cell.textLabel?.text = element.name!
            return cell
            }.disposed(by: bag)
    }
}
