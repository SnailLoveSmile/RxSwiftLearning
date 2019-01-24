//
//  UIViewControllerRxExtendViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UIViewControllerRxExtendViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        //页面显示状态完毕
        self.rx.isVisiable.subscribe(onNext: { visible in
            print("当前页面显示状态：\(visible)")
        }).disposed(by: bag)
        /*
         //页面加载完毕
         self.rx.viewDidLoad.subscribe(onNext: {
         self.title = "给 UIViewController 添加 RxSwift 扩展"
         self.view.backgroundColor = UIColor.white
         }).disposed(by: bag)

         //页面将要显示
         self.rx.viewWillAppear
         .subscribe(onNext: { animated in
         print("viewWillAppear")
         }).disposed(by: bag)

         //页面显示完毕
         self.rx.viewDidAppear
         .subscribe(onNext: { animated in
         print("viewDidAppear")
         }).disposed(by: bag)*/
    }
  

}
