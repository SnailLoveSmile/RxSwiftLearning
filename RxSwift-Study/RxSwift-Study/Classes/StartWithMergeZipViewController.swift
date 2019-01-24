//
//  StartWithMergeZipViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class StartWithMergeZipViewController: BaseViewController {
    let bag = DisposeBag()
    //结合操作指的是将多个Observable序列进行组合，拼装成一个新的Observable。
    override func viewDidLoad() {
        super.viewDidLoad()

        print("-----------startWith--------------startWith-----")
        //startWith: 在Observable序列开始之前插入一些元素，即发出事件之前，会先发出这些预先插入的事件。
        Observable.of("2","3").startWith("1").subscribe(onNext: {print($0)}).disposed(by: bag)
        /*
         1
         2
         3
         */

        print("-----------merge--------------merge-----")
        //merge:合并多个Observable为一个Observable
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        Observable.of(subject1, subject2).merge().subscribe(onNext: {print($0)}).disposed(by: bag)
        subject1.onNext(20)
        subject1.onNext(40)
        subject1.onNext(60)
        subject2.onNext(0)
        subject1.onNext(80)
        subject1.onNext(100)
        subject2.onNext(0)
        /*
         20
         40
         60
         0
         80
         100
         0
         */

        print("-----------zip--------------zip-----")
        //zip: 该方法将多个Observable序列压缩成一个Observable序列，而且会等到每个Observable事件一一对应地凑齐之后再合并。
        let subject3 = PublishSubject<Int>()
        let subject4 = PublishSubject<String>()

        Observable.zip(subject3, subject4) {
            "\($0)\($1)"
            }.subscribe(onNext: {print($0)}).disposed(by: bag)
        subject3.onNext(1)
        subject4.onNext("A")
        subject3.onNext(2)
        subject4.onNext("B")
        subject4.onNext("C")
        subject4.onNext("D")
        subject3.onNext(3)
        subject3.onNext(4)
        subject3.onNext(5)
        /*
         1A
         2B
         3C
         4D
         */

         print("-----------combineLatest--------------combineLatest-----")

        //combineLatest: 整合多个Observable，不同的是：每当任意一个Observable有新的事件产生时候，就会将其他Observable序列最新的事件用来合并

        let subject5 = PublishSubject<Int>()
        let subject6 = PublishSubject<String>()

        Observable.combineLatest(subject5, subject6) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: bag)

        subject5.onNext(1)
        subject6.onNext("A")
        subject5.onNext(2)
        subject6.onNext("B")
        subject6.onNext("C")
        subject6.onNext("D")
        subject5.onNext(3)
        subject5.onNext(4)
        subject5.onNext(5)
        /*
         1A
         2A
         2B
         2C
         2D
         3D
         4D
         5D
         */

        print("-----------withLatestForm--------------withLatestForm-----")
    //withLatestForm:将两个Observable合并成一个，每当第一个队列发射一个元素时候，便从第二个序列中取出一个新值并发送出去。


        let pb1 = PublishSubject<Int>()
        let pb2 = PublishSubject<Int>()

        pb1.withLatestFrom(pb2)
            .subscribe { event in
                switch event {
                case .next(let element):
                    print("element-----:", element)
                case .error(let error):
                    print("error:", error)
                case .completed:
                    print("completed")
                }}
            .disposed(by: bag)

        pb2.onNext(2)
        pb1.onNext(1)
        /*
         输出：
         element-----: 2
         */
        print("-----------------")
        pb1.withLatestFrom(pb2, resultSelector: { (i1, i2) -> Int in
            print("i1=\(i1)  i2=\(i2)")
            return i1 + i2
        }).subscribe { event in
            switch event {
            case .next(let element):
                print("element:", element)
            case .error(let error):
                print("error:", error)
            case .completed:
                print("completed")
            }}
            .disposed(by: bag)

        pb1.onNext(1)
        pb2.onNext(2)
        pb1.onNext(3)
        pb1.onCompleted()

        /*
         输出：
         -----------------
         i1=3  i2=2
         element: 5
         completed
         completed

         pb2发出了2，pb1最后发出了3，2+3=5。
         */



    }

}
