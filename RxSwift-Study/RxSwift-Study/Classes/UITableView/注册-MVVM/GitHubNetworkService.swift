//
//  GitHubNetworkService.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/22.
//  Copyright © 2019 incich. All rights reserved.
//

import Foundation
import RxSwift

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}


class GitHubNetworkService {

    func usernameAvailable(_ username: String) -> Observable<Bool> {
        let url = URL.init(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest.init(url: url)
        return URLSession.shared.rx.response(request: request).map{ (arg0)  in
            return arg0.response.statusCode == 404

        }.catchErrorJustReturn(false)
    }

    func singup(_ username: String, password: String) -> Observable<Bool> {
        //模拟操作, 1.5s后返回这个结果
        let signupResult = arc4random() % 2 == 0 ? false:true
        return Observable.just(signupResult).delay(1.5, scheduler: MainScheduler.instance)
    }
}
