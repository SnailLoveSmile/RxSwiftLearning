//
//  UITextFieldUITextViewViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UITextFieldUITextViewViewController: BaseViewController {
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        //.orEmpty可以将String?类型的ControlProperty转换成String
        let textField = UITextField(frame: CGRect(x: 10, y: 100, width: 200, height: 30))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)

//        textField.rx.text.orEmpty.subscribe(onNext:{print($0)}).disposed(by: bag)
        textField.rx.text.orEmpty.changed.subscribe(onNext:{print($0)}).disposed(by: bag)



        let inputField = UITextField(frame: CGRect(x: 10, y: 140, width: 200, height: 30))
        inputField.borderStyle = .roundedRect
        view.addSubview(inputField)

        let outputField = UITextField(frame: CGRect(x: 10, y: 200, width: 200, height: 30))
        outputField.borderStyle = .roundedRect
        view.addSubview(outputField)


        let label = UILabel(frame: CGRect(x: 20, y: 250, width: 200, height: 30))
        view.addSubview(label)

        let button = UIButton(type: .system)
        button.frame = CGRect(x: 20, y: 290, width: 40, height: 30)

        button.setTitle("提交", for: .normal)
        view.addSubview(button)



        let input = inputField.rx.text.orEmpty.asDriver()
            .throttle(0.3)
        input.drive(outputField.rx.text).disposed(by: bag)
        input.map{"当前字数: \($0.count)"}.drive(label.rx.text).disposed(by: bag)
        input.map{$0.count>5}.drive(button.rx.isEnabled).disposed(by: bag)

        button.rx.tap.subscribe(onNext:{
            print("taped button")
        }).disposed(by: bag)




        //同时监听多个textfield的变化
        let textField_1 = UITextField(frame: CGRect(x:10, y:330, width:200, height:30))
        textField_1.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(textField_1)

        let textField_2 = UITextField(frame: CGRect(x:10, y:370, width:200, height:30))
        textField_2.borderStyle = UITextField.BorderStyle.roundedRect
        self.view.addSubview(textField_2)

        let label_1 = UILabel(frame:CGRect(x:20, y:400, width:220, height:30))
        self.view.addSubview(label_1)

        Observable.combineLatest(textField_1.rx.text.orEmpty, textField_2.rx.text.orEmpty) { (text1, text2) in
            "输入的是: \(text1)-\(text2)"
        }.bind(to: label_1.rx.text).disposed(by: bag)



        //事件监听
        //通过rx.ControlEvent可以监听输入框的各种事件，且多个事件状态可以自由组合。除了UI控件都有的touch事件外，还有如下几个事件：
        /*

         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件

         **/
        textField.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: {print("开始编辑")
        }).disposed(by: bag)

        //下面代码我们在界面上添加两个输入框分别用于输入用户名和密码：如果当前焦点在用户名输入框时，按下 return 键时焦点自动转移到密码输入框上。如果当前焦点在密码输入框时，按下 return 键时自动移除焦点。
        let nameTF = UITextField(frame: CGRect(x:10, y:450, width:200, height:30))
        nameTF.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(nameTF)

        let passTF = UITextField(frame: CGRect(x:10, y:490, width:200, height:30))
        passTF.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(passTF)
        nameTF.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {passTF.becomeFirstResponder()}).disposed(by: bag)
        passTF.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext:{passTF.resignFirstResponder()}).disposed(by: bag)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


}
