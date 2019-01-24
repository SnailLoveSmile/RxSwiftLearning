//
//  SubjectsVariablesViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SubjectsViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         Subjects 既是订阅者也是Observable, 既可以动态的接收新的值也可以有了新的值后通过event将值发给其他的订阅者,subject几个常用方法：onNext()、onError()、onCompleted()。
         *一共有4种sujects:
         0. AsyncSubject:将在源 Observable 产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源 Observable 没有发出任何元素，只有一个完成事件。那 AsyncSubject 也只有一个完成事件。如果源 Observable 因为产生了一个 error 事件而中止， AsyncSubject 就不会发出任何元素，而是将这个 error 事件发送出来。
         1. PublishSubject: 最普通的subject, 不需要初始值就能创建, 只能接收到订阅后的新的event, 不能接收到订阅前发出的event

         2. BehaviorSubject: 需要通过一个默认值进行创建, 订阅者订阅后可以收到BehaviorSubject上一个以及以后发出的event事件
         3. ReplaySubject: 创建的时候需要一个bufferSize, 如果一个订阅者订阅了这个subject, 这个订阅者会立即收到之前的bufferSize个的event
         4. BehaviorReplay: 作为替代Variable的替代者出现, 本质也是和Variable 一样是对BehaviorSubject的封装, 所以必须接收一个默认值进行创建. BehaviorRelay 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
         与 BehaviorSubject 不同的是，BehaviorRelay 会在销毁时自动发送 .complete 的 event，不需要也不能手动给 BehaviorReply 发送 completed 或者 error 事件来结束它。
         BehaviorRelay 有一个 value 属性，我们通过这个属性可以获取最新值。而通过它的 accept() 方法可以对值进行修改
         */

//AsyncSubject
        let async = AsyncSubject<String>()
        async.subscribe { (event) in
            print("event")
        }.disposed(by: bag)
        async.onNext("1")
        async.onNext("2")
        async.onNext("3")
        async.onCompleted()


        /*
          Event: next(🐹)
          Event: completed
         */









        //1. PublishSubject

        let publish = PublishSubject<String>()
        publish.onNext("0000")
        publish.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (_) in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)
        publish.onNext("1111")
        publish.onNext("2222")
        publish.onCompleted()
        /*
         以上代码当发出"0000"事件前没有subscribe, 所以接收不到0000事件, 能接收到1111之后的所有事件
         */

        //2.BehaviorSubject
        let behavior = BehaviorSubject(value: 0)

        behavior.onNext(1)
        behavior.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (_) in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)
        behavior.onNext(2)
        behavior.onCompleted()
        /*
         以上代码在subscribe之前发出的一个元素是1,只能接收到1之后的事件, 0已经不能被订阅了
         */

        //3.ReplaySubject
        let replay = ReplaySubject<String>.create(bufferSize: 2)
        replay.onNext("0")
        replay.onNext("1")
        replay.onNext("2")
        replay.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (_) in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)
        replay.onNext("3")
        replay.onNext("4")
        replay.onCompleted()
        /*
         以上因为bufferSize为2 只能接收到subscribe之前发出的两个元素以及以后的事件
         */


        //4.BehaviorRelay
        let behaviorRelay = BehaviorRelay<[Int]>(value: [])
        behaviorRelay.accept([1])
        behaviorRelay.accept(behaviorRelay.value + [2])
        behaviorRelay.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (_) in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)
        behaviorRelay.accept(behaviorRelay.value + [3])
        behaviorRelay.accept(behaviorRelay.value + [4])

        /*
         BehaviorRelay是对BehaviorSubject的封装, 会在subscribe时接收到前一个以及以后的事件
         */

    }

}
