//
//  ListModel.swift
//  RxSwift-Study
//
//  Created by apple on 2019/1/21.
//  Copyright © 2019 incich. All rights reserved.
//

import UIKit
import HandyJSON

struct ListItemModel: HandyJSON {
    var name_en: String?
    var seq_id: String?
    var abbr_en: String?
    var name: String?
    var channel_id: String?
}

struct ListModel:HandyJSON {
    var channels:[ListItemModel]?
}
