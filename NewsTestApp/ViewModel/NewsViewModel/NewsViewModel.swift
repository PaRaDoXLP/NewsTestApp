//
//  NewsViewModel.swift
//  NewsTestApp
//
//  Created by Вячеслав on 10/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import RealmSwift
import Alamofire

class NewsViewModel {
    var news:Array<NTANewsEntity> = []
    let provider = MoyaProvider<NTAEndpointsManager>()
    var page = 1
    var pageSize = 5
    var isMorePages = true
    var isConnected = true
    var updateBlock: NTAVoidBlock?
    var selectionBlock: NTADataBlock?
    var errorBlock: NTAErrorBlock?
    var networkBlock: NTANetworkBlock?
    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    var currentRequest: Cancellable?
    
    
    init() {
        reachabilityManager?.startListening { status in
            self.isConnected = status != .notReachable
            print("Network Status Changed: \(status)")
            
            if (self.isConnected == false) {
                if (self.currentRequest != nil) {
                    self.currentRequest?.cancel()
                }
            } else {
                if (self.currentRequest != nil) {
                    self.isMorePages = true
                    self.loadNews()
                }
            }
            if (self.networkBlock != nil) {
                self.networkBlock!(status)
            }
        }
    }
    
    func getNewsCount() -> Int {
      return news.count
    }
    
    func updateNews() {
        if self.isConnected {
            self.page = 1
            self.isMorePages = true
            self.loadNews()
        } else {
            if self.updateBlock != nil {
                self.updateBlock!()
            }
        }
    }
    
    
    
    func initialLoadNews() {
        self.isConnected = reachabilityManager!.isReachable
        if self.isConnected {
            //WITH INTERNET CONNECTION
            
            if (self.isMorePages) {
                self.currentRequest = NTANetworkManager.sharedInstance.getNextPages(page: page, pageSize: pageSize) { [weak self] (news, error) in
                    if error != nil {
                        if self?.errorBlock != nil {
                            self?.errorBlock!(error)
                        }
                    } else {
                        guard let articles = news else {
                            return
                        }
                        if (self?.page == 1) {
                            self?.news.removeAll()
                        }
                        
                        if articles.count > 0 {
                            self?.news.append(contentsOf:articles)
                            self?.page += 1
                        } else {
                            self?.isMorePages = false
                        }
                        
                        if self?.updateBlock != nil {
                            self?.updateBlock!()
                        }
                    }
                    self?.currentRequest = nil
                }
            } else {
                return
            }
        } else {
            //WITHOUT INTERNET CONNECTION
            let newsArray:Array<NTANewsEntity> = NTADatabaseManager.sharedInstance.allNews()
            self.news.removeAll()
            self.news.append(contentsOf:newsArray)
            self.isMorePages = false
        }
    }
    
    func loadNews() {
        if (self.isMorePages) {
            self.currentRequest = NTANetworkManager.sharedInstance.getNextPages(page: page, pageSize: pageSize) { [weak self] (news, error) in
                if error != nil {
                    if self?.errorBlock != nil {
                        self?.errorBlock!(error)
                    }
                } else {
                    guard let articles = news else {
                        return
                    }
                    if (self?.page == 1) {
                        self?.news.removeAll()
                    }
                    
                    if articles.count > 0 {
                        self?.news.append(contentsOf:articles)
                        self?.page += 1
                    } else {
                        self?.isMorePages = false
                    }
                    
                    if self?.updateBlock != nil {
                        self?.updateBlock!()
                    }
                }
                self?.currentRequest = nil
            }
        } else {
            return
        }
    }

    func cellViewModel(atIndexPath indexPath: IndexPath) -> NTANewsCellViewModel {
        
        let entity = self.news[indexPath.row]
        let vm = NTANewsCellViewModel.init(newsEntity:entity)
        
        vm.selectBlock = {[weak self,entity] in
            if self?.selectionBlock != nil {
                self?.selectionBlock!(entity)
            }
        }
        
        return vm
    }
    
}
