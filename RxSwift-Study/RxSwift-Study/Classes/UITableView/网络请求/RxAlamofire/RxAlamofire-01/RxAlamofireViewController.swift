//
//  RxAlamofireViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/20.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
class RxAlamofireViewController: BaseViewController {


    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL.init(string: urlString)
        startBtn.rx.tap.asObservable().throttle(1.5, scheduler: MainScheduler.instance).flatMap { _ in
            request(.get, url!).responseString().takeUntil(self.cancelBtn.rx.tap)
            }.subscribe(onNext: { (rsponse: HTTPURLResponse, data: String) in
                print("请求成功, 返回数据为\(data)")}, onError: { error in
                    print(error)
            }).disposed(by: bag)



    }
}
