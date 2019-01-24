//
//  ObservableSubscribeDoonDisposeViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ObservableSubscribeDoonDisposeViewController: BaseViewController {

    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let ob1 = Observable.of(1, 3, 5)
        ob1.subscribe { (event) in
            print(event)
        }.disposed(by: bag)

        ob1.subscribe(onNext: { (element) in
            print(element)
        }, onError: { _ in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)

        ob1.subscribe(onNext: { element in
                print(element)
        }).disposed(by: bag)
    }
}
