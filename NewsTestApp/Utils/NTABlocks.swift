//
//  NTABlocks.swift
//  NewsTestApp
//
//  Created by Вячеслав on 11/03/2020.
//  Copyright © 2020 PaRaDoX. All rights reserved.
//

import Foundation
import Alamofire

typealias NTADataBlock = (Any?) -> Void
typealias NTANetworkBlock = (NetworkReachabilityManager.NetworkReachabilityStatus?) -> Void
typealias NTAVoidBlock = () -> Void
typealias NTAPagesComletionBlock =  ([NTANewsEntity]?, NTAError?) -> Void
typealias NTAErrorBlock = (NTAError?) -> Void
