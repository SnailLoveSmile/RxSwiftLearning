//
//  UILabelViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class UILabelViewController: BaseViewController {
    var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        view.addSubview(label)

        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        timer.map{String(format: "%02d:%02d.%02d.%02d", $0/360000, $0/6000, $0/10)}.bind(to: label.rx.text).disposed(by: bag)

        //将数据绑定到attributeText属性上
        let label_2 = UILabel(frame:CGRect(x:20, y:200, width:300, height:100))
        view.addSubview(label_2)

        timer.map{self.formatTimeInterval(ms: $0)}.bind(to: label_2.rx.attributedText).disposed(by: bag)
        delay(10) {//这里销毁bag, 释放了timer就可以回收资源了
            self.bag = DisposeBag()
        }
    }
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))

        return attributeString
    }
    func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
