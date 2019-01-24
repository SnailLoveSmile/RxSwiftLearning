//
//  AnyObserverBinderViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AnyObserverBinderViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         观察者的作用就是监听event事件, 然后对这个event做出响应, 或者说任何响应event事件的行为都是观察者
            1. 点击按钮弹出弹出框, "弹出提示框"就是观察者Observable<Viod>
            2. 请求json数据后, 打印json数据, "打印json数据"也是观察者Observable<Json>
         直接在subscribe, bind方法中创建f观察者
            1. 在subscribe方法中创建, 当事件发生时做出对应的响应
         */
        let ob1 = Observable.of("1", "2", "3")
        ob1.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (_) in
            print("error")
        }, onCompleted: {
            print("completed")
        }).disposed(by: bag)

        //2. bind方法中创建
        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"--索引数: \($0)"}.bind { (element: String) in
            print(element)
        }.disposed(by: bag)


        //使用AnyObserver观察者
        let anyOb = AnyObserver<String>.init { (event) in
            switch event {
            case .next(let element):
                print(element)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }

        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{
            "索引数: \($0)"
        }.bind(to: anyOb).disposed(by: bag)


        let label = UILabel(frame: CGRect(x: 20, y: 80, width: 150, height: 45))
        label.backgroundColor = .red
        label.textColor = .white
        view.addSubview(label)

        let binder = Binder<String>(label){ label, text in
            label.text = text
        }

        Observable<Int>.interval(1, scheduler: MainScheduler.instance).map{"当前索引数:\($0)"}.bind(to: binder).disposed(by: bag)
    }

}
