//
//  ConnectPublishReplayMulticastViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ConnectPublishReplayMulticastViewController: BaseViewController {
    let bag = DisposeBag()

    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

       /**
         可连接序列
         1. 可连接序列和一般序列不同: 有订阅的时候不会立即开始发送事件消息, 只有当调用connect()之后才会开始发送值
         2. 可连接序列可以让所有订阅者订阅后, 才开始发送事件消息, 从而保证想要的所有订阅者都可以接收到事件消息
        */

//        testFirst()
//        testSecond()
//        testThree()
//        testFour()
//        testFive()
        testSix()
    }
}
extension ConnectPublishReplayMulticastViewController {
     func testFirst() {

        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        interval.subscribe(onNext:{print("订阅1:\($0)")}).disposed(by: bag)
        delay(5) {
            interval.subscribe(onNext:{print("订阅2:\($0)")}).disposed(by: self.bag)
        }
        /*
         订阅1:0
         订阅1:1
         订阅1:2
         订阅1:3
         订阅1:4
         订阅1:5
         订阅2:0
         订阅1:6
         订阅2:1
         订阅1:7
         订阅2:2
         订阅1:8
         订阅2:3
         可以看到第一个订阅者订阅后，每隔 1 秒会收到一个值。而第二个订阅者 5 秒后才收到第一个值 0，所以两个订阅者接收到的值是不同步的
         */
    }

    // publish: 将一个正常的序列改造成一个可连接序列, 同事该序列不会立即发送事件, 只有在调用connect之后才会开始
    func testSecond() {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
        interval.subscribe(onNext:{print("订阅1:\($0)")}).disposed(by: bag)
        //事件延迟两秒执行
        delay(2) {
            interval.connect().disposed(by: self.bag)
        }
        delay(5) {
            interval.subscribe(onNext:{print("订阅2:\($0)")}).disposed(by: self.bag)
        }
        /*
         .
         . 这里2s后开始订阅事件
         订阅1:0
         订阅1:1
         订阅1:2
         订阅1:3
         订阅2:3
         订阅1:4
         订阅2:4
         订阅1:5
         订阅2:5
         订阅1:6
         订阅2:6
         订阅1:7
         订阅2:7
         订阅1:8
         订阅2:8
         订阅1:9
         订阅2:9
         */
    }

    /* replay:
     1. replay与publish相同在于: 会将一个正常的序列转为一个可连接序列, 同时该序列不会立刻发送事件, 只有在调用connect之后才会开始
     2. 不同在于: 新的订阅者还能接收到订阅之前的事件消息(数量由设置的bufferSize决定)
    */


    func testThree() {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(5)
        interval.subscribe(onNext:{print("订阅者1:\($0)")}).disposed(by: bag)
        delay(2) {
            interval.connect().disposed(by: self.bag)
        }
        delay(5) {
            interval.subscribe(onNext:{print("订阅者2:\($0)")}).disposed(by: self.bag)
        }
        /*
         .
         . 2s后开始订阅
         订阅者1:0
         订阅者1:1
         订阅者2:0   --->5s了, 订阅者2开始订阅, 并接到了
                            //bufferSize=2的前两个
         订阅者2:1
         订阅者1:2
         订阅者2:2
         订阅者1:3
         订阅者2:3
         订阅者1:4
         订阅者2:4
         订阅者1:5
         订阅者2:5
         订阅者1:6
         订阅者2:6
         */
    }

    //muticast: 同样可以将一个正常的序列转为一个可连接的序列.同时muticast方法还可以传入一个subject, 每当序列发送事件时候, 都会触发这个Subject的发送
    func testFour()  {
        let subject = PublishSubject<Int>()
        subject.subscribe(onNext:{print("subject: \($0)")}).disposed(by: bag)

        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(subject)
        interval.subscribe(onNext:{print("订阅1: \($0)")}).disposed(by: bag)
        delay(2) {
            interval.connect().disposed(by: self.bag)
        }
        delay(5) {
             interval.subscribe(onNext:{print("订阅2: \($0)")}).disposed(by: self.bag)
        }
        /*
         .
         .
         subject: 0
         订阅1: 0
         subject: 1
         订阅1: 1
         subject: 2   -->5s 后
         订阅1: 2
         subject: 3
         订阅1: 3
         订阅2: 3
         subject: 4
         订阅1: 4
         订阅2: 4
         subject: 5
         订阅1: 5
         订阅2: 5
         subject: 6
         订阅1: 6
         订阅2: 6
         subject: 7
         订阅1: 7
         订阅2: 7
         subject: 8
         订阅1: 8
         订阅2: 8
        */
    }

    // refCount: 可以将可被连接的Observable转为普通的Observable, 即该操作可以自动连接和断开可连接的Observable, 当第一个观察者对可连接的Observable订阅时候, 那么底层的Observable自动被连接, 最后一个观察者离开时, 底层的Observable将被自动断开连接

    func testFive() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
            .refCount()

        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })

        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
        /*
         订阅1: 0
         订阅1: 1
         订阅1: 2
         订阅1: 3
         订阅1: 4
         订阅1: 5
         订阅2: 5
         订阅1: 6
         订阅2: 6
         订阅1: 7
         订阅2: 7
         */
    }

    //share(relay:): 该操作符将使得观察者共享Observable, 并且缓存最新的n个元素, 将这些元素直接发送给新的观察者, 简单来说shareReplay就是replay和refCount的结合
    func testSix() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .share(replay: 2)

        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })

        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
        /*
         订阅1: 0
         订阅1: 1
         订阅1: 2
         订阅1: 3
         订阅1: 4
         订阅2: 0
         订阅2: 1
         订阅2: 2
         订阅2: 3
         订阅2: 4
         订阅1: 5
         订阅2: 5
         订阅1: 6
         订阅2: 6
         订阅1: 7
         订阅2: 7
         */
    }


}
