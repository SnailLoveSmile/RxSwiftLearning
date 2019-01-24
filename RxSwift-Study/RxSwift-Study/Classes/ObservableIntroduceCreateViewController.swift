//
//  ObservableIntroduceCreateViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ObservableIntroduceCreateViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        

        //Just
         _ = Observable.just(5)

        //of
        //该方法接收可变的参数, 但是参数类型必须相同
         _ = Observable.of("1", "2", "3")

        //from
         _ = Observable.from([1, 3, 5])

        //empty
         _ = Observable<Int>.empty()

        // never
         _ = Observable<String>.never()

        //error
        enum MyError: Error {
            case error_A
            case error_B
        }
         _ = Observable<Int>.error(MyError.error_A)

        //range
         _ = Observable.range(start: 1, count: 9)

        //repeatElement
         _ = Observable.repeatElement(2)

        //generate - 当condition条件为true时任务结束
         _ = Observable.generate(initialState: 0, condition: {$0 <= 10}, iterate: {$0 + 2})

        //creat
         _ = Observable<String>.create { (obser) -> Disposable in
            obser.onNext("1")
            obser.onCompleted()
            return Disposables.create()
        }

        //deferred - 通过传入 block 在其中延迟执行创建Observable动作
        var isOdd = true
        let factory = Observable<Int>.deferred { () -> Observable<Int> in
            isOdd.toggle()

            if isOdd {
                return Observable.of(1, 3, 5)
            } else {
                return Observable.of(2, 4, 6)
            }
        }
        _ = factory.subscribe{ event in
            print(event.element ?? 11111)
        }
         _ = factory.subscribe{ event in
            print(event.element ?? 88888)
        }

        //interval - 每隔一段时间发出一个索引数的元素
         _ = Observable<Int>.interval(1, scheduler: MainScheduler.instance)

        //timer - 5秒后发出唯一一个元素0
         _ = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
            //5秒后创建一个每隔2秒发出一个Int元素的序列
         _ = Observable<Int>.timer(5, period: 2, scheduler: MainScheduler.instance)

    }
}
