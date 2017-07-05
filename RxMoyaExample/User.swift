//
//  File.swift
//  RxMoyaExample
//
//  Created by chendi li on 2017/7/4.
//  Copyright © 2017年 dcubot. All rights reserved.
//

import Foundation
import ObjectMapper
import HandyJSON
class User: Mappable {
    /// This function is where all variable mappings should occur. It is executed by Mapper during the mapping (serialization and deserialization) process.
    func mapping(map: Map) {
//        <#code#>
    }

    required /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    init?(map: Map) {
//        <#code#>
    }

    
}

struct People: HandyJSON {
    
}
