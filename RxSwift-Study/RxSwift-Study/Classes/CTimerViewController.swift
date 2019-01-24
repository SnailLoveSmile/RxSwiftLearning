
//
//  CTimerViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CTimerViewController: BaseViewController {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!

    let bag = DisposeBag()
    var leftTime = BehaviorRelay.init(value: TimeInterval(180))
    var countDownStop = BehaviorRelay.init(value: true)
    override func viewDidLoad() {
        super.viewDidLoad()

            _ = self.datePicker.rx.countDownDuration <-> self.leftTime

        //绑定button标题

        Observable.combineLatest(leftTime, countDownStop) { leftTimeValue, countDownStopValue in

            if countDownStopValue {
                return "开始"
            } else {
                return "剩余: \(Int(leftTimeValue)) 秒"
            }

            }.bind(to: startBtn.rx.title()).disposed(by: bag)


        //绑定button和datePicker的可用状态
        let countDown = countDownStop.asDriver()
        countDown.drive(datePicker.rx.isEnabled).disposed(by: bag)
        countDown.drive(startBtn.rx.isEnabled).disposed(by: bag)



        startBtn.rx.tap.bind { _ in
            self.startClicked()
        }.disposed(by: bag)

    }

    func startClicked() {
        self.countDownStop.accept(false)

        Observable<Int>.interval(1, scheduler: MainScheduler.instance).takeUntil(countDownStop.filter{$0 == true}).subscribe { (event) in
            self.leftTime.accept(self.leftTime.value - 60)
            if self.leftTime.value <= 0 {
                self.countDownStop.accept(true)
                self.leftTime.accept(180)
            }

        }.disposed(by: bag)
    }
}
