//
//  Environments.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation

/**
 System environments
 */
struct Environments{
    static let rpc = Bundle.main.object(forInfoDictionaryKey: "RPC_ENDPOINT") as? String
    static let contractAddress = Bundle.main.object(forInfoDictionaryKey: "CONTRACT") as? String
}
