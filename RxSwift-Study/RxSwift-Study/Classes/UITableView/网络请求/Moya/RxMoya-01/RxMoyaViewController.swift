//
//  RxMoyaViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class RxMoyaViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        DouBanProvider.rx.request(.channels).subscribe{ event in
            switch event {
            case .success(let response):
                let str = String.init(data: response.data, encoding: .utf8)
                print("返回数据为: \(str ?? "nothing is found")")
            case .error(let error):
                print(error.localizedDescription)
            }
        }.disposed(by: bag)
    }
}
