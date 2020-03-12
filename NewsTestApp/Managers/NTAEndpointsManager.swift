//
//  NTANetworkManager.swift
//  NewsTestApp
//
//  Created by Вячеслав on 09/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation
import Moya

public enum NTAEndpointsManager {
    case news(Int, Int)
}

extension NTAEndpointsManager: TargetType {
    public var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    public var path: String {
        switch self {
        case .news: return "/everything"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .news: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .news(let page, let pageSize):
            return .requestParameters(parameters: [ "page": "\(page)",
                                                    "pageSize" : "\(pageSize)",
                                                    "q" : "ios",
                                                    "from" : "2019-04-00",
                                                    "sortBy" : "publishedAt",
                                                    "apiKey" : "26eddb253e7840f988aec61f2ece2907"],
                                      encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
