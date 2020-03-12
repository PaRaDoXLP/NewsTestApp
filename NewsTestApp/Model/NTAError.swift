//
//  NTAError.swift
//  NewsTestApp
//
//  Created by Вячеслав on 12/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation
import ObjectMapper

class NTAError: ImmutableMappable, CustomNSError {
    
    var message: String = ""
    var status: String = ""
    var code: String = ""
    var allInfo: [String: Any] = [:]
    
    required convenience init(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        code <- map["code"]
        allInfo = map.JSON
    }
    
}
