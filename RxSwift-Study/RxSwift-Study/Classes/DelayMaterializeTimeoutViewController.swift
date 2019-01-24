//
//  DelayMaterializeTimeoutViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class DelayMaterializeTimeoutViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---------delay---------delay--")
        //delay: 将Observable的所有元素都延迟一定的时间后发出(延迟发送)
        Observable.of(1, 3, 5).delay(3, scheduler: MainScheduler.instance).subscribe(onNext:{print($0)}).disposed(by: bag)
        print("---------delaySubscription---------delaySubscription--")
        //delaySubscription: 延迟订阅
        Observable.of(2, 4, 6).delaySubscription(3, scheduler: MainScheduler.instance).subscribe(onNext:{print($0)}).disposed(by: bag)

         print("---------dematerialize---------dematerialize--")

        //dematerialize: 将转换后的元素还原成一个Observable
        Observable.of(1, 2, 1).materialize().dematerialize().subscribe(onNext:{print($0)}).disposed(by: bag)
 print("---------timeout---------timeout--")

        //timeout: 设置一个超时时间, 再规定时间内没有发出时间就会产生一个error事件.
        let times = [["value":1, "time":0],
                     ["value":2, "time":0.5],
                     ["value":3, "time":0.5],
                     ["value":4, "time":4],
                     ["value":5, "time":5]
                     ]

        Observable.from(times).flatMap { item in
            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
            }.timeout(2, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}, onError: { (error) in
                print(error)
            }, onCompleted: {
                print("complete")
            }).disposed(by: bag)
    }
    


}
