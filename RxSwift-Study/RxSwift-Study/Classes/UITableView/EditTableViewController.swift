//
//  EditTableViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/18.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum TableEditingCommand {
    case setItems(items: [String])//设置表格数据
    case addItem(item: String)//添加数据
    case moveItem(from: IndexPath, to: IndexPath)//移动
    case deleteItem(IndexPath)//删除数据
}

struct TableViewModel {
    var items: [String]
    init(items: [String] = []) {
        self.items = items
    }

    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(items: let items):
            return TableViewModel.init(items: items)
        case .addItem(item: let item):
            var items = self.items
            items.append(item)
            return TableViewModel.init(items: items)
        case let .moveItem(from: from, to: to):
            var items = self.items
            items.insert(items.remove(at: from.row), at: to.row)
            return TableViewModel.init(items: items)
        case .deleteItem(let index):
            var items = self.items
            items.remove(at: index.row)
            return TableViewModel.init(items: items)
        }

    }
}


class EditTableViewController: BaseViewController {
    let bag = DisposeBag()
    fileprivate let cellID = "cellId"
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

        return table
    }()
    lazy var refreshBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle("刷新", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    lazy var addBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle("添加", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()
    lazy var editBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle("编辑", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)
        let addBarItem = UIBarButtonItem(customView: self.addBtn)
        let refreshBarItem = UIBarButtonItem(customView: self.refreshBtn)
        let editeBarItem = UIBarButtonItem(customView: self.editBtn)
        navigationItem.rightBarButtonItems = [refreshBarItem, addBarItem, editeBarItem]

        //刷新数据命令
        let refreshCommand = self.refreshBtn.rx.tap.asObservable().startWith(()).flatMapLatest(getRandomResult).map(TableEditingCommand.setItems)
        //新增条目命令
        let addCommand = addBtn.rx.tap.asObservable()
            .map{ "\(arc4random())" }
            .map(TableEditingCommand.addItem)


        editBtn.rx.tap.subscribe { [weak self] (event) in
            self?.tableView.isEditing.toggle()
        }.disposed(by: bag)

        //移动位置命令
        let movedCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)

        //删除条目命令
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
            .map(TableEditingCommand.deleteItem)
        let initialVM = TableViewModel()
        //绑定单元格数据
        Observable.of(refreshCommand, addCommand, movedCommand, deleteCommand)
            .merge()
            .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand)
                -> TableViewModel in
                return vm.execute(command: command)
            }.map {
                print($0)
               return [AnimatableSectionModel(model: "", items: $0.items)]
            }
            .share(replay: 1)
            .bind(to: tableView.rx.items(dataSource: self.dataSource()))
            .disposed(by: bag)


    }



    func getRandomResult() -> Observable<[String]> {
        let items = (0..<5).map{ _ in
            "\(arc4random())"
        }
        return Observable.just(items)
    }

    func dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, String>> {
        return RxTableViewSectionedAnimatedDataSource(
            //设置插入、删除、移动单元格的动画效果
            animationConfiguration: AnimationConfiguration(insertAnimation: .top,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .left),
            configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier:self.cellID)!
                cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                return cell
        },
            canEditRowAtIndexPath: { _, _ in
                return true //单元格可删除
        },
            canMoveRowAtIndexPath: { _, _ in
                return true //单元格可移动
        }
        )
    }
}
