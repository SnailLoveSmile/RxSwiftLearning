//
//  CustomBindablePropertyViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CustomBindablePropertyViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.width, height: 25))
        label.text = "Binder"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 0)
        label.backgroundColor = .green
        view.addSubview(label)

// Observable<Int>.interval(0.5, scheduler: MainScheduler.instance).map{CGFloat($0)}.bind(to: label.font_size).disposed(by: bag)

        Observable<Int>.interval(0.5, scheduler: MainScheduler.instance).map{CGFloat($0)}.bind(to: label.rx.fontsize).disposed(by: bag)
    }

}

//1. 对UI类进行扩展
extension UILabel {
    var font_size: Binder<CGFloat> {
        return Binder(self){ label, font_size in
            label.font = UIFont.systemFont(ofSize: font_size)
        }
    }
}
//2. 对Reactive进行扩展
extension Reactive where Base:UILabel {
    var fontsize:Binder<CGFloat> {
        return Binder(self.base){ label, fontsize in
            label.font = UIFont.systemFont(ofSize: fontsize)
        }
    }
}

