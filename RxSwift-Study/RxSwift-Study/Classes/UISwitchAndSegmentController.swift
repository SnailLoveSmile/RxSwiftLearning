//
//  UISwitchAndSegmentController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class UISwitchAndSegmentController: BaseViewController {
    let bag = DisposeBag()
    @IBOutlet weak var mySwitch: UISwitch!

    @IBOutlet weak var showView: UIView!

    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let colors = [UIColor.red, UIColor.blue, UIColor.yellow]
        mySwitch.rx.isOn.bind(to: showView.rx.isHidden).disposed(by: bag)

    segment.rx.selectedSegmentIndex.asObservable().map{colors[$0]}.bind(to: showView.rx.bgColor).disposed(by: bag)
    }
}

extension Reactive where Base: UIView {
    var bgColor: Binder<UIColor> {
        return Binder(self.base){ view, color in
            view.backgroundColor = color
        }
    }
}
