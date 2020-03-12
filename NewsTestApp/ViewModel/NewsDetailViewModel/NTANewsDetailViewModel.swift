//
//  NTANewsDetailViewModel.swift
//  NewsTestApp
//
//  Created by Вячеслав on 11/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation

class NTANewsDetailViewModel {
    
    var newsEntity: NTANewsEntity? {
        didSet{
            self.newsTitle = self.newsEntity!.title
            self.newsURL = URL.init(string:self.newsEntity!.url)!
        }
    }
    
    var newsTitle: String = ""
    var newsURL: URL?
    
    
    init(newsEntity: NTANewsEntity) {
        self.setNewsEntry(newsEntity: newsEntity)
    }
    
    func setNewsEntry(newsEntity: NTANewsEntity) {
        self.newsEntity = newsEntity
    }
}
