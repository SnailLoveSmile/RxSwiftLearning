//
//  UIButtonUIBarButtonItemViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UIButtonUIBarButtonItemViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 200, width: 150, height: 30)
        button.backgroundColor = .red

        button.setTitle("点击", for: .normal)
        view.addSubview(button)

        button.rx.tap.subscribe(onNext:{ [weak self] in
            self?.showMessage("Are you ready! ")
        }).disposed(by: bag)

        methodTwo()


    }
   @objc func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let conformAction = UIAlertAction(title: "确定", style: .destructive) { _ in
            print("ok")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .default) { _ in
            print("cancel")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(conformAction)
    present(alertController, animated: true, completion: nil)
    }

}
extension UIButtonUIBarButtonItemViewController {
    func methodTwo() {
        var buttons = [UIButton]()
        for i in 0..<3 {
            let button = UIButton(frame: CGRect(x: 20+CGFloat(i)*100, y: 300, width: 80, height: 40))
            button.setTitleColor(.red, for: .selected)
            button.tag = 1000 + i
            button.setTitleColor(.green, for: .normal)
            button.setTitleColor(.purple, for: .highlighted)
            button.setTitle("按钮", for: .normal)
            view.addSubview(button)
            button.isSelected = (i == 0)
            buttons.append(button)
        }

        //创建一个可观察序列, 他可以发送最后一次点击的按钮(也就是我们需要选中的按钮)
        let selectedBtn = Observable.from(buttons.map{btn in btn.rx.tap.map{btn}}).merge()

        //对于每一个按钮都会selectedBtn进行订阅, 根据它是否是当前选中的按钮绑定isSelected属性
        for btn in buttons {
            selectedBtn.map{
                print(btn.tag)
                return $0 == btn}.bind(to: btn.rx.isSelected).disposed(by: bag)
        }
        
        /*
      selectedBtn.map{ btn in
            print(btn.tag)
            buttons.forEach {
                $0.isSelected = ($0 == btn)
            }
        }.subscribe().disposed(by: bag)*/
    }
}
