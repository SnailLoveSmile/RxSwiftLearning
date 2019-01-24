//
//  RxMoya+HandyJson.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import Foundation
import RxSwift
import HandyJSON
import Moya

extension ObservableType where E == Response {
   public func mapModel<T: HandyJSON>(T: T.Type) -> Observable<T> {
        return flatMap({ (response) -> Observable<T> in
            print(T.self)
            return Observable.just(response.mapModel(type: T.self))
        })
    }
}

extension Response {
    func mapModel<T: HandyJSON>(type: T.Type) -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        guard let modelT = JSONDeserializer<T>.deserializeFrom(json: jsonString) else {
            return JSONDeserializer<T>.deserializeFrom(json: "{msg:'请求有误'}")!
        }
        return modelT
    }
}
