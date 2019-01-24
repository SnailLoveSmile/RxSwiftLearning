//
//  DouBan.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift

//数据映射错误

public enum RxObjectMapperError:Error {
    case parsingError
}

//扩展Observable:增加模型映射方法
public extension Observable where Element: Any {
    //将JSON数据转为对象类型
    public func mapObject<T>(type: T.Type) -> Observable<T> where T: Mappable {
        let mapper = Mapper<T>()
        return self.map{element -> T in
            guard let parseElement = mapper.map(JSONObject: element) else { throw RxObjectMapperError.parsingError}
            return parseElement
        }
    }

    //将JSON数据转为数组
    public func mapArray<T>(type: T.Type) -> Observable<[T]> where T: Mappable {
        let mapper = Mapper<T>()
        return self.map{element -> [T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedArray
        }
    }

}

class Channel: Mappable {
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }

    var name: String?
    var nameEn: String?
    var channelId: String?
    var seqId: String?
    var abbrEn: String?


}

class  Douban: Mappable {
    var channels: [Channel]?
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        channels <- map["channels"]
    }
}
