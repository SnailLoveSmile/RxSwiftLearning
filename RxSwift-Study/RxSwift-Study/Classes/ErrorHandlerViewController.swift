//
//  ErrorHandlerViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ErrorHandlerViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("--------catchErrorJustReturn-----------catchErrorJustReturn------------------")
        //catchErrorJustReturn: 当遇到error事件的时候，就返回指定的值，然后结束
        enum MyError: Error {
            case a
            case b
        }

        let subject1 = PublishSubject<String>()
        subject1.catchErrorJustReturn("错误").subscribe(onNext:{print($0)}).disposed(by: bag)
        subject1.onNext("A")
        subject1.onNext("B")
        subject1.onError(MyError.a)
        subject1.onNext("C")
        /*
         A
         B
         错误
         */
        print("--------catchError-----------catchError------------------")
        //catchError: 捕获error进行处理, 汉能返回另一个Observable进行订阅(切换新序列)
        let subject2 = PublishSubject<Int>()
        let ob2 = Observable.of(1, 2, 3)
        subject2.catchError { (error) -> Observable<Int> in
            print(error)
            return ob2
            }.subscribe(onNext:{print($0)}).disposed(by: bag)
        subject2.onNext(1)
        subject2.onNext(2)
        subject2.onError(MyError.b)
        /*
         1
         2
         b
         1
         2
         3
         */
 print("--------retry-----------retry------------------")
        //retry: 当遇到错误的时候，可以重新订阅该序列，比如遇到网络请求失败，可以进行重新连接，retry方法可以传入重试次数，不传的话只重试一次。
        var count = 1
        let ob3 = Observable<String>.create { (ob) -> Disposable in
            ob.onNext("1")
            ob.onNext("2")
            if count == 1 {
                ob.onError(MyError.a)
                print("error is coming")
                count += 1
            }
            ob.onNext("3")
            ob.onNext("4")
            ob.onCompleted()
            return Disposables.create()
        }
        ob3.retry(2).subscribe(onNext:{print($0)}).disposed(by: bag)

        /*
         1
         2
         error is coming
         1
         2
         3
         4
         */
    }
}
