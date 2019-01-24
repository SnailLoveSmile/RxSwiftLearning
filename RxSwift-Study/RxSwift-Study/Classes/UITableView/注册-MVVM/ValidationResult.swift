//
//  ValidationResult.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit

enum ValidationResult {
    case validating //正在验证中
    case empty //输入为空
    case ok(message: String)
    case failed(message: String)
}
extension ValidationResult: CustomStringConvertible {
//对应不同的验证结果返回验证是成功还是失败
    var isVaild: Bool {
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
//对应不同的验证结果返回不同的文字描述
    var description: String {
        switch self {
        case .validating:
            return "验证中...."
        case .empty:
            return ""
        case .ok(message: let msg):
            return msg
        case .failed(message: let msg):
            return msg
        }
    }
//对应不同的验证结果返回不同的文字颜色
    var textColor: UIColor {
        switch self {
        case .validating:
            return .gray
        case .empty:
            return .black
        case .ok:
            return .green
        case .failed:
            return .red
        }
    }
}
