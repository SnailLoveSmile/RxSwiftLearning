//
//  BBViewController.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class BBViewController: BaseViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    let bag = DisposeBag()
    var model = BBModel()
    override func viewDidLoad() {
        super.viewDidLoad()



      /*  model.userName.bind(to: textField.rx.text).disposed(by: bag)

        textField.rx.text.orEmpty.bind(to: model.userName).disposed(by: bag)*/

        _ = textField.rx.textInput <-> model.userName

        model.userInfo.bind(to:resultLabel.rx.text).disposed(by: bag)
    }

}
