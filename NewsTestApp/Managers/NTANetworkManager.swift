//
//  NTANetworkManager.swift
//  NewsTestApp
//
//  Created by Вячеслав on 12/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import RealmSwift

class NTANetworkManager: NSObject {
    
    static let sharedInstance = NTANetworkManager()
    
    let provider = MoyaProvider<NTAEndpointsManager>()
    
    func getNextPages(page: Int, pageSize: Int, completion: @escaping NTAPagesComletionBlock) -> Cancellable {
        
        return provider.request(.news(page, pageSize)) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .success(let response):
                do {
                    let responseJSON:AnyObject = try response.mapJSON() as AnyObject
                    
                    let articles = responseJSON["articles"] as Any
                    switch articles {
                    case Optional<Any>.none:
                        let error: NTAError = try Mapper<NTAError>().map(JSONObject: responseJSON)
                        print("\(error)")
                        completion(nil, error)
                    default:
                        let newsFromJSON: Array<NTANewsEntity> = Mapper<NTANewsEntity>().mapArray(JSONObject: articles)!
                        NTADatabaseManager.sharedInstance.saveNewsEntity(newsEntities: newsFromJSON)
                        completion(newsFromJSON, nil)
                    }
                } catch {
                    print("SOME ERROR")
                }
            case .failure(let error):
                
                print("FAIL ERROR")
                let ntaError: NTAError = NTAError()
                ntaError.message = error.errorDescription!
                ntaError.code = "\(error.errorCode)"
                ntaError.status = "Fail"
                completion(nil, ntaError)
            }
            
        }
    }

}
