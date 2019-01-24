//
//  BBModel.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct BBModel {
    let userName = BehaviorRelay.init(value: "guest")
    lazy var userInfo: Observable<String> = {
        return self.userName.map{$0 == "admin" ? "管理员":"游客"}
    }()
}
