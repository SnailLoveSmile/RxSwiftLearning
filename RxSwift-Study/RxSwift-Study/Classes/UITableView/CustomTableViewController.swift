//
//  CustomTableViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


class SectionsView: UITableViewHeaderFooterView {

    var titleLabel: UILabel!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .blue
        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: 40)
        contentView.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomTableViewController: BaseViewController {
    let bag = DisposeBag()
    fileprivate let cellID = "cellId"
    fileprivate let sectionID = "sectionID"
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        table.register(SectionsView.self, forHeaderFooterViewReuseIdentifier: sectionID)
        return table
    }()
    var datasource: RxTableViewSectionedReloadDataSource<SectionModel<String, String>>?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)

        let sections = Observable.just([SectionModel.init(model: "First Section", items: ["one", "two", "three"]), SectionModel.init(model: "Section Section", items: ["001", "002", "003", "004"])])

        let dataS = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {(ds, tv, index, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: self.cellID)
            cell?.textLabel?.text = element
            return cell!
        })
        self.datasource = dataS
//        dataS.titleForHeaderInSection = {ds, index in
//            return "共有\(ds.sectionModels[index].items.count)个内容"
//        }

        sections.bind(to: self.tableView.rx.items(dataSource: dataS)).disposed(by: bag)
        self.tableView.rx.setDelegate(self as UITableViewDelegate).disposed(by: bag)
    }
}

extension CustomTableViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionID) as! SectionsView

        headerView.titleLabel.text = "共有\(String(describing: self.datasource?.sectionModels[section].items.count ?? 0))个内容"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        }
}
