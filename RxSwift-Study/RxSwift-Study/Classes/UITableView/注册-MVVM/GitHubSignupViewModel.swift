//
//  GitHubSignupViewModel.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 incich. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GitHubSignupViewModel {
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword:Driver<ValidationResult>
    let validatedpasswordRepeated:Driver<ValidationResult>
    let signupEnabled: Driver<Bool>
    let signupResult: Driver<Bool>


    init(input: (username:Driver<String>, password:Driver<String>, repeatedPassword:Driver<String>, logintaps: Signal<()>),
         dependency: (
        networkService: GitHubNetworkService, signupService: GitHubSignupService)
         ) {

        validatedUsername = input.username.flatMapLatest{
            dependency.signupService.validateUsername($0).asDriver(onErrorJustReturn: .failed(message: "服务器错误"))
        }
        validatedPassword = input.password.map{
            dependency.signupService.validatePassword($0)
        }
        validatedpasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: dependency.signupService.validateRepeatedPassword)
        signupEnabled = Driver.combineLatest(validatedUsername, validatedPassword,validatedpasswordRepeated){ username, password, repeatPassword in
            username.isVaild && password.isVaild && repeatPassword.isVaild

        }.distinctUntilChanged()

        let usernameAndPassword = Driver.combineLatest(input.username, input.password){(username: $0, password: $1)}

        signupResult = input.logintaps.withLatestFrom(usernameAndPassword).flatMap{

            dependency.networkService.singup($0.username, password: $0.password).asDriver(onErrorJustReturn: false)
        }

    }


}
