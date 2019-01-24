//
//  DriverViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit

class DriverViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*Driver:
            1. 不会产生error事件
            2. 一定是在主线程监听
            3. 共享状态变化
         常用于:
            1. 使用CoreData模型驱动UI
            2. 使用一个UI元素驱动另外一个UI元素
         */
        /*
         let results = query.rx.text.asDriver()
            //在主线程中操作,0.3s内值若是多次改变只取最后一次
         .throttle(0.3, scheduler: MainScheduler.instance)
         .flatMapLatest{ query in
            fetchAutoCompleteItems(query)//向服务器请求一组结果
         .asDriver(onErrorJustReturn:[])//发生错误提供一组备选返回值
         }
         */
        /*
        //将返回的结果绑定到显示结果数量的label上
        results.map { "\($0.count)" }
            .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
            .disposed(by: disposeBag)

        //将返回的结果绑定到tableView上
        results
            .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
                (_, result, cell) in
                cell.textLabel?.text = "\(result)"
            }.disposed(by: disposeBag)
        */

        //首先使用asDriver将ControlPropety转换为Driver。接着我们可以用.asDriver(onErrorJustReturn:[])方法将任何Observable都转换为Driver。
        /*
         而 asDriver(onErrorJustReturn: []) 相当于以下代码：
         let safeSequence = xs
         .observeOn(MainScheduler.instance) // 主线程监听
         .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
         .share(replay: 1, scope: .whileConnected)// 共享状态变化
         return Driver(raw: safeSequence) // 封装
         **/
    }


}
