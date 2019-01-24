//
//  FilterTakeSkipViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class FilterTakeSkipViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~~~~~~~~~~~filter~~~~~~~~~~~~~~~~~filter~~~~~~~~~~~filter~~~~~~~~~")
        //filter: 筛选出符合闭包条件的事件
        Observable.of(20, 21, 12, 34, 22, 3, 43, 324).filter{$0>30}.subscribe(onNext:{print($0)}).disposed(by: bag)
        /*
         34
         43
         324
         */ print("~~~~~~~~~~~~~~distinctUntilChange~~~~~~~~~~~~~~~~~distinctUntilChange~~~~~~~~~~~distinctUntilChange~~~~~~~~~")
        //distinctUntilChange: 过滤掉连续重复的事件
        Observable.of(1, 2, 2, 3, 2, 4, 4, 4, 5, 5, 6).distinctUntilChanged().subscribe(onNext:{print($0)}).disposed(by: bag)
        /*
         1
         2
         3
         2
         4
         5
         6
         */ print("~~~~~~~~~~~~~~single~~~~~~~~~~~~~~~~~single~~~~~~~~~~~single~~~~~~~~~")
        //single: 限制只发送一次事件, 或者说是满足条件的第一个事件, 如果存在多个事件或者没事件都会发出一个error事件, 仅有一个事件发生才不会有error产生
        Observable.of(1, 2, 3, 4).single({$0 == 2}).subscribe { (event) in
            print(event)
            }.disposed(by: bag)
        /*
         next(2)
         completed
         */
        Observable.of("A", "B", "C", "D").single().subscribe(onNext:{
            print($0)
        }).disposed(by: bag)
        /*
         A
         Unhandled error happened: Sequence contains more than one element.
         */
        print("~~~~~~~~~~~~~~elememtAt~~~~~~~~~~~~~~~~~elememtAt~~~~~~~~~~~elememtAt~~~~~~~~~")

        //elememtAt: 获取指定位置的事件
        Observable.of(1, 2, 3, 4).elementAt(2).subscribe(onNext:{print($0)}).disposed(by: bag)
        /*
         3
         */
        Observable.of(1, 2, 3, 4).elementAt(8).subscribe(onNext:{print($0)}).disposed(by: bag)
        /*
         Unhandled error happened: Argument out of range.
         subscription called from:
         */
        print("~~~~~~~~~~~~~~ignoreElements~~~~~~~~~~~~~~~~~ignoreElements~~~~~~~~~~~ignoreElements~~~~~~~~~")

        // ignoreElement: 该操作符可以忽略掉所有的的元素，只发出error或completed事件。如果我们不关心Observable的所有元素，只关心Observable在什么时候终止，那就可以用ignoreElement。
        Observable.of(1,2,3,4).ignoreElements().subscribe {print($0)}.disposed(by: bag)
        /*completed*/
        print("~~~~~~~~~~~~~~take~~~~~~~~~~~~~~~~~take~~~~~~~~~~~take~~~~~~~~~")
        //take: 实现仅发送Observable序列的前n个事件，在满足数量之后会自动.completed
        Observable.of(1, 2, 3, 4).take(2).subscribe(onNext:{print($0)}).disposed(by: bag)
        /*
         1
         2
         */
        print("~~~~~~~~~~~~~~takeLast~~~~~~~~~~~~~~~~~takeLast~~~~~~~~~~~takeLast~~~~~~~~~")
        //takeLast: 仅接收Observable序列的后n个事件
        Observable.of(1,2,3,4,5).takeLast(3).subscribe(onNext: {print($0)}).disposed(by: bag)
        /*
         3
         4
         5
         */
        print("~~~~~~~~~~~~~~skip~~~~~~~~~~~~~~~~~skip~~~~~~~~~~~skip~~~~~~~~~")
        //skip: 跳过Observable序列发出的前n个事件,接收n+1后的所有事件
        Observable.of(1,2,3,4,5).skip(2).subscribe(onNext: {print($0)}).disposed(by: bag)
        /*
         3
         4
         5
         */
        print("~~~~~~~~~~~~~~sample~~~~~~~~~~~~~~~~~sample~~~~~~~~~~~sample~~~~~~~~~")

        //sample: 除了订阅源外，还可以监听另一个Observable，即notifier。每当收到notifier事件，就会从源序列取一个最新的事件并发送，而如果两次notifier事件之间没有源序列的事件，则不发送值。
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        source.sample(notifier).subscribe(onNext:{print($0)}).disposed(by: bag)
        source.onNext(1)
        source.onNext(2)
        notifier.onNext("A")//发出: 2
        source.onNext(3)
        notifier.onNext("B")//只能发出一次: 3
        notifier.onNext("C")
        source.onNext(4)
        source.onNext(5)
        notifier.onCompleted()//发出: 5
        source.onCompleted()
        /*
         2
         3
         5
         */


        print("~~~~~~~~~~~~~~takeUntil~~~~~~~~~~~~~~~~~takeUntil~~~~~~~~~~~takeUntil~~~~~~~~~")

        /*
         takeUntil
         除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
         如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。

         */


        let first = PublishSubject<String>()
        let second = PublishSubject<String>()

        first
            .takeUntil(second)
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)

        first.onNext("a")
        first.onNext("b")
        first.onNext("c")
        first.onNext("d")

        //停止接收消息
        second.onNext("z")

        first.onNext("e")
        first.onNext("f")
        first.onNext("g")





        /*
         a
         b
         c
         d
         */





        print("~~~~~~~~~~~~~~debounce~~~~~~~~~~~~~~~~~debounce~~~~~~~~~~~debounce~~~~~~~~~")
        //debounce: debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生，换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。

        let times = [
            [ "value": 1, "time": 0.1 ],
            [ "value": 2, "time": 1.1 ],
            [ "value": 3, "time": 1.2 ],
            [ "value": 4, "time": 1.2 ],
            [ "value": 5, "time": 1.4 ],
            [ "value": 6, "time": 2.1 ]
        ]

        //生成对应的Observable序列并订阅
        Observable.from(times).flatMap {item in

            return Observable.of(Int(item["value"]!)).delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)


            }.debounce(0.5, scheduler: MainScheduler.instance).subscribe(onNext: {print($0)}).disposed(by: bag)
        /*
         1
         5
         6
         */

    }
    



}
