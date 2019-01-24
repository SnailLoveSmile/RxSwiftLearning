//
//  ToArrayReduceConcatViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ToArrayReduceConcatViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("---------toArray---------toArray----")
        //toArray:将一个序列变成一个数组，并作为一个单一的序列发送
        Observable.of(1, 2, 3).toArray().subscribe(onNext:{print($0)}).disposed(by: bag)
        /*[1, 2, 3] */
        print("---------scan---------scan----")
        //scan: 后面的事件, 对前面所有事件的处理
        Observable.of(1, 2, 3).scan(0, accumulator: +).subscribe(onNext: {print($0)}).disposed(by: bag)
        /*
         1
         3
         6
         */
        print("---------reduce---------reduce----")
        //reduce: 接收一个初始值和一个操作符，将给定的初始值使用操作符累计运算，得到一个最终的结果，并将其作为单个值发出去。
        Observable.of(1, 2, 3, 4, 5).reduce(0, accumulator: +).subscribe(onNext: { print($0)
        }).disposed(by: bag)//15

        print("---------concat---------concat----")
        //concat: 将多个Observable合并成一个, 只有前一个Observable发出complete事件后一个的Observable事件才会被接收

        let sb1 = BehaviorSubject(value: 1)
        let sb2 = BehaviorSubject(value: 100)

        let behaviorRelay = BehaviorRelay(value: sb1)
        behaviorRelay.asObservable().concat().subscribe(onNext:{print($0)}).disposed(by: bag)
        sb1.onNext(2)
        sb1.onNext(3)

        sb2.onNext(200)
        behaviorRelay.accept(sb2)
        sb2.onNext(300)
        sb1.onNext(4)
        sb1.onCompleted()//sb1发出complete事件, 此时sb2接收信息, 因为是BehaviorSubject接收到sb2的上一个事件为300, 以及以后的事件400
        sb2.onNext(400)
        sb2.onCompleted()
        /*
         1
         2
         3
         4
         300
         400
         */
    }


}
