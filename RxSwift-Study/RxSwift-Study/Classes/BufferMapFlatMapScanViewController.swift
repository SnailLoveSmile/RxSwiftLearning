//
//  BufferMapFlatMapScanViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class BufferMapFlatMapScanViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~~~~~~~~~~~buffer~~~~~~~~~~~~~~~~~buffer~~~~~~~~~~~buffer~~~~~~~~~")
        //1. buffer: 缓冲组合, 第一个参数是缓冲时间, 第二个缓冲个数, 第三个是线程, 缓冲Observable中发出的新元素, 当元素达到指定的数量, 或者到达了指定时间, 就会将这些元素发送出来, eg:缓存个数3, 如果达到了3个或者1秒内不够3个都会发出事件(有个发出几个, 没有的话指定时间到之后发出空数组)
        let pulishSub = PublishSubject<String>()
        pulishSub.buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext:{print("buffer:\($0)")}).disposed(by: bag)
        pulishSub.onNext("a")
        pulishSub.onNext("b")
        pulishSub.onNext("c")
        pulishSub.onNext("e")
        pulishSub.onNext("1")
        pulishSub.onNext("2")
        pulishSub.onNext("3")
        pulishSub.onNext("4")
        pulishSub.onNext("5")//["a", "b", "c"],["e", "1", "2"],["3", "4", "5"]
        pulishSub.onNext("6")//["6"]//6会单发, 以后一直是空的数组发出
        pulishSub.onCompleted()
        print("~~~~~~~~~~~~~~window~~~~~~~~~~~~~~~~~window~~~~~~~~~~~window~~~~~~~~~")
        //2. window 周期性的将元素集合以Observable的形态发出, 而且可以实时发出元素序列, 不需要等到元素集合完成后既可以发出序列
        let window = PublishSubject<Int>()
        window.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).subscribe(onNext:{
            print($0)
            print("----------------")
            return $0.asObservable().subscribe(onNext:{ element in
                print(element)
            }).disposed(by: self.bag)}).disposed(by: bag)
        window.onNext(0)
        window.onNext(1)
        window.onNext(2)
        window.onNext(3)
        window.onNext(4)
        window.onNext(5)
        window.onNext(6)
        window.onCompleted()
        /**
         RxSwift.AddRef<Swift.Int>
         ----------------
         0
         1
         2
         RxSwift.AddRef<Swift.Int>
         ----------------
         3
         4
         5
         RxSwift.AddRef<Swift.Int>
         ----------------
         6
         由此可以看出window的包装形式
         */


        print("~~~~~~~~~~~~~~map~~~~~~~~~~~~~~~~~map~~~~~~~~~~~map~~~~~~~~~")

        //3. map:通过传入一个闭包, 把原来的Observable序列转换成一个新的序列
        Observable.of(1, 2, 3).map{$0 * 10}.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)

        print("~~~~~~~~~~~~~~flatMap~~~~~~~~~~~~~~~~~flatMap~~~~~~~~~~~flatMap~~~~~~~~~")
        //4. flatmap:map在做转换的时候容易出现“升维”的情况，就是从一个序列变成一个序列的序列，但是flatMap操作符会对源Observable的每一个元素应用一个转换方法，将他们变成Observables，然后将这些Observables的元素合并之后再发送出来。即又将其“拍扁”（降维）成一个Observable序列。eg：比如当Observable的元素本身就拥有其他的Observable时候，我们可以将所有子OBservables的元素发送出来。

        let subject3 = BehaviorSubject(value: "A")
        let subject4 = BehaviorSubject(value: "1")

        let behaviorReplay = BehaviorRelay<BehaviorSubject>(value: subject3)
        behaviorReplay.asObservable().flatMap {$0}.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)
        subject3.onNext("B")
        behaviorReplay.accept(subject4)
        subject3.onNext("C")
        subject4.onNext("2")
        subject3.onNext("D")
        subject4.onNext("3")
        subject3.onCompleted()
        subject4.onCompleted()
        /*
         A
         B
         1
         C
         2
         D
         3
         */
        print("~~~~~~~~~~~~~~flatMapLatest~~~~~~~~~~~~~~~~~flatMapLatest~~~~~~~~~~~flatMapLatest~~~~~~~~~")

        //5. flatMapLatest: 与flatMap唯一的区别就是：flatMapLatest只会接收最新的value事件。

        let subject5 = BehaviorSubject(value: "A")
        let subject6 = BehaviorSubject(value: "1")

        let behaviorReplay1 = BehaviorRelay<BehaviorSubject>(value: subject5)
        behaviorReplay1.asObservable().flatMapLatest {$0}.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)

        subject5.onNext("B")
        subject5.onNext("C")
        subject6.onNext("2")
        behaviorReplay1.accept(subject6)
        subject5.onNext("D")//这里D不会再接收
        subject6.onNext("3")
        subject5.onCompleted()
        subject6.onCompleted()
        /*
         A
         B
         C
         2
         3
         */
        print("~~~~~~~~~~~~~~flatMapFirst~~~~~~~~~~~~~~~~~flatMapFirst~~~~~~~~~~~flatMapFirst~~~~~~~~~")
        //6. flatMapFirst: 与flatMap唯一的区别就是：只会接收最初的value事件

        let subject7 = BehaviorSubject(value: "A")
        let subject8 = BehaviorSubject(value: "1")

        let behaviorReplay2 = BehaviorRelay<BehaviorSubject>(value: subject8)
        behaviorReplay2.asObservable().flatMapFirst {$0}.subscribe(onNext:{
            print($0)
        }).disposed(by: bag)

        subject7.onNext("B")
        subject7.onNext("C")
        subject8.onNext("2")
        behaviorReplay2.accept(subject7)
        subject7.onNext("D")
        subject8.onNext("3")
        subject7.onNext("E")
        subject8.onNext("4")
        subject7.onCompleted()
        subject8.onCompleted()
        /*
         1
         2
         3
         4
         */

        print("~~~~~~~~~~~~~~concatMap~~~~~~~~~~~~~~~~~concatMap~~~~~~~~~~~concatMap~~~~~~~~~")

        //7. concatMap:与flatMap唯一的区别就是：当前一个Observable元素发送完毕后，后一个Observable才可以开始发出元素，也就是等待前一个Observable产生完成事件，才对后一个Observable进行订阅。

        let ob1 = BehaviorSubject(value: "A")
        let ob2 = BehaviorSubject(value: "1")
        let behaviRe = BehaviorRelay<BehaviorSubject>(value: ob1)
        behaviRe.asObservable().concatMap { $0
            }.subscribe(onNext: {print($0)}).disposed(by: bag)
        ob1.onNext("B")
        ob2.onNext("2")
        ob1.onNext("C")
        behaviRe.accept(ob2)
        ob2.onNext("3")
        ob1.onNext("D")
        ob2.onNext("4")
        ob1.onNext("E")
        ob1.onCompleted()
        ob2.onNext("5")
        ob2.onNext("6")
        ob2.onCompleted()
        /*
         A
         B
         C
         D
         E
         4
         5
         6
         */

        print("~~~~~~~~~~~~~~groupBy~~~~~~~~~~~~~~~~~groupBy~~~~~~~~~~~groupBy~~~~~~~~~")
        //8. groupBy: 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来，也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。eg:将奇偶数分成两组

        Observable.of(0, 1, 2, 3, 4, 5, 6).groupBy { (num) in
            return (num % 2 == 0) ? "os":"js"
            }.subscribe(onNext:{ group in
                group.subscribe(onNext:{print(group.key + "\($0)")}).disposed(by: self.bag)
            }).disposed(by: bag)
        /*
         os0
         js1
         os2
         js3
         os4
         js5
         os6*/
        print("~~~~~~~~~~~~~~scan~~~~~~~~~~~~~~~~~scan~~~~~~~~~~~scan~~~~~~~~~")

        // 9. scan: 先给一个初始化的数，然后不断地拿前一个结果和最新的值进行处理操作。


        Observable.of(1,2,3,4,5).scan(0) { acum, elem in
            acum + elem
            }.subscribe(onNext: {print($0)}).disposed(by: bag)

        /**
         1
         3
         6
         10
         15
         */


    }

}
