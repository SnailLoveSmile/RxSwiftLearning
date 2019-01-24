//
//  DouBanAPI.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import Foundation
import Moya

let DouBanProvider = MoyaProvider<DoubanAPI>()

public enum DoubanAPI {
    case channels
    case playlist(String)
}

extension DoubanAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL.init(string: "https://www.douban.com")!
        case .playlist(_):
            return URL.init(string: "https://douban.fm/")!
        }
    }
    public var path: String {
            switch self {
            case .channels:
                return "/j/app/radio/channels"
            case .playlist(_):
                return "/j/mine/playlist"
            }
        }

    public var method: Moya.Method {
            return .get
        }
        // 做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
            return "{}".data(using: .utf8)!
        }

    public var task: Task {
            switch self {
            case .playlist(let channel):
                var params: [String: Any] = [:]
                params["channel"] = channel
                params["type"] = "n"
                params["from"] = "mainsite"
                return .requestParameters(parameters: params, encoding: URLEncoding.default)
            default:
                return .requestPlain
            }
        }
    // 请求头
    public var headers: [String : String]? {
        print("header is in")
            return nil
        }



}

