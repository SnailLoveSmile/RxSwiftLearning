
//
//  TableViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources


struct MySection {
    var header: String
    var items: [Item]
}
extension MySection: AnimatableSectionModelType {


    typealias Item = String
    typealias Identity = String
    var identity: String {return header}
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}


class TableViewController: BaseViewController {

   fileprivate let cellID = "cellid"
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        return table
    }()

    let bag = DisposeBag()



    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)

        let sections = Observable.just([MySection(header: "自定义Section", items: ["数据刷新+过滤", "样式修改", "编辑表格"])])

        let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(configureCell: { ds, tv, indexPath, item in

            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID)!

            cell.textLabel?.text = item
            return cell
        })

        dataSource.titleForHeaderInSection = {ds, index in
            return ds.sectionModels[index].header
        }

        // 绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        self.tableView.rx.modelSelected(String.self).subscribe(onNext: {
            switch $0 {
            case "数据刷新+过滤":
                self.navigationController?.pushViewController(ReloadTableViewController(), animated: true)
            case "编辑表格":
                print("编辑表格")
                self.navigationController?.pushViewController(EditTableViewController(), animated: true)
            case "样式修改":
                print("样式修改")
                self.navigationController?.pushViewController(CustomTableViewController(), animated: true)
            default:
                break
            }
        }).disposed(by: bag)
    }
}
