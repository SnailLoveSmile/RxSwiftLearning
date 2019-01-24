//
//  ReloadTableViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
class ReloadTableViewController: BaseViewController {
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
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        return searchBar
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)
        self.tableView.tableHeaderView = self.searchBar

        let cancelBarItem = UIBarButtonItem(customView: self.cancelBtn)
        let refreshBarItem = UIBarButtonItem(customView: self.refreshBtn)
        navigationItem.rightBarButtonItems = [refreshBarItem, cancelBarItem]


        let randomResult = self.refreshBtn.rx.tap.asObservable().startWith(()).flatMapLatest{self.getRandomResult().takeUntil(self.cancelBtn.rx.tap)}.flatMap(filterResult).share(replay: 1)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { ds, tb, index, element in
            let cell = tb.dequeueReusableCell(withIdentifier: self.cellID)!
            cell.textLabel?.text = "条目\(index.row): \(element)"
            return cell
        })
        randomResult.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: bag)
    }

}
extension ReloadTableViewController {
   fileprivate func getRandomResult() -> Observable<[SectionModel<String, Int>]>{
        print("正在请求数据....")
        let items = (0..<5).map{ _ in
            Int(arc4random())
        }

 //throttle, 设定时间后发生一个事件, 中间改变多少次不会重新计算也不会发生事件, 直到设定时间到了就会执行(如果在1秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。)
//debounce, 只有间隔超过设定时间才发送, 多次触发不足设定时间会重新计算直到设定时间到了事件才发送, 譬如搜索, 文字输入多次间隔不足设定时间都会重新计算,不会触发事件, 文字输入超过设定时间才会发出搜索事件
        let observable = Observable.just([SectionModel.init(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
   fileprivate func filterResult(data: [SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        return self.searchBar.rx.text.orEmpty
            .debounce(1, scheduler: MainScheduler.instance) //只有间隔超过1秒才发送, 多次触发不足1s会重新计算知道1s后事件才发送
            .flatMapLatest{
                query -> Observable<[SectionModel<String, Int>]> in
                print("正在筛选数据（条件为：\(query)）")
                //输入条件为空，则直接返回原始数据
                if query.isEmpty {
                    return Observable.just(data)
                } else {//输入条件为不空，则只返回包含有该文字的数据
                    var newData:[SectionModel<String, Int>] = []
                    for sectionModel in data {
                        let items = sectionModel.items.filter{ "\($0)".contains(query) }
                        newData.append(SectionModel(model: sectionModel.model, items: items))
                    }
                    return Observable.just(newData)
                }
        }
    }
}
/*
 防止表格多次刷新的说明
 （1）flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapLatest(getRandomResult)  //连续请求时只取最后一次数据
 .share(replay: 1)

 （2）也可以改用 flatMapFirst 来防止表格多次刷新，它与 flatMapLatest 刚好相反，如果连续发起多次请求，表格只会接收并显示第一次请求。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapFirst(getRandomResult)  //连续请求时只取第一次数据
 .share(replay: 1)

 （3）我们还可以在源头进行限制下。即通过 throttle 设置个阀值（比如 1 秒），如果在1秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。

 //随机的表格数据
 let randomResult = refreshButton.rx.tap.asObservable()
 .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
 .startWith(()) //加这个为了让一开始就能自动请求一次数据
 .flatMapLatest(getRandomResult)
 .share(replay: 1)
 */
