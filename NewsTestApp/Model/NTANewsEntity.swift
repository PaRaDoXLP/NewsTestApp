//
//  NTANewsEntity.swift
//  NewsTestApp
//
//  Created by Вячеслав on 10/03/2020.
//Copyright © 2020 PaRaDoX. All rights reserved.
//

import RealmSwift
import ObjectMapper

class NTANewsEntity: Object, Mappable {
    
    @objc dynamic var title = ""
    @objc dynamic var newsDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var publishedAt = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        newsDescription <- map["description"]
        url <- map["url"]
        imageUrl <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
    
    override class func primaryKey() -> String? {
        return "publishedAt"
    }
}
