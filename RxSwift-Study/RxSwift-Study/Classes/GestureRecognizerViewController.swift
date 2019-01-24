//
//  GestureRecognizerViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class GestureRecognizerViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        view.addGestureRecognizer(swipe)
        
        swipe.rx.event.subscribe(onNext:{ recognizer in
            let point = recognizer.location(in:recognizer.view)
            print("向上滑动-- x:\(point.x) y:\(point.y)")
        }).disposed(by: bag)
        


        /*
         swipe.rx.event.bind { recognizer in
         let point = recognizer.location(in: recognizer.view)
         print("向上滑动 -- x:\(point.x) y:\(point.y)")
         }.disposed(by: disposeBag)
        */

    }
    


}
