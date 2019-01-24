//
//  GitHubSignupService.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import RxSwift
class GitHubSignupService {
    let minLength = 5
    lazy var networkService = {
        return GitHubNetworkService()
    }()

    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        guard !username.isEmpty else {
            return Observable.just(.empty)
        }
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return Observable.just(.failed(message: "用户名只能包含数字和字母"))
        }

        return networkService.usernameAvailable(username).map{ available in
            available ? .ok(message: "可用"):.failed(message: "已存在")
        }

    }


    func validatePassword(_ password: String) -> ValidationResult{
        let numberOfCharaters = password.count

        if numberOfCharaters == 0 {
            return .empty
        }

        if numberOfCharaters < minLength {
            return .failed(message: "密码至少需要 \(minLength) 个字符")
        }

        return .ok(message: "密码有效")
    }

    func validateRepeatedPassword(_ password: String, repeatedPassword: String)
        -> ValidationResult {
            //判断密码是否为空
            if repeatedPassword.count == 0 {
                return .empty
            }

            //判断两次输入的密码是否一致
            if repeatedPassword == password {
                return .ok(message: "密码有效")
            } else {
                return .failed(message: "两次输入的密码不一致")
            }
    }

}
