//
//  NTANewsCellViewModel.swift
//  NewsTestApp
//
//  Created by Вячеслав on 11/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation

class NTANewsCellViewModel {
    
    var newsEntity: NTANewsEntity? {
        didSet{
            self.newsTitle = self.newsEntity!.title
            self.newsDescription = self.newsEntity!.newsDescription
            self.newsURL = URL.init(string:self.newsEntity!.url)
            self.imageURL = URL.init(string:self.newsEntity!.imageUrl)
            self.date = self.convertDate(self.newsEntity!.publishedAt)
        }
    }
    
    var newsTitle: String = ""
    var newsDescription: String = ""
    var newsURL: URL?
    var imageURL: URL?
    var date: String = ""
    var selectBlock: NTAVoidBlock?
    
    
    init(newsEntity: NTANewsEntity) {
        self.setNewsEntry(newsEntity: newsEntity)
    }
    
    func setNewsEntry(newsEntity: NTANewsEntity) {
        self.newsEntity = newsEntity
    }
    
    func convertDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:dateString)!
        
        dateFormatter.dateFormat = "HH:mm:ss dd/MM/yyyy"
        let str = dateFormatter.string(from:date)
        return str
    }
}
