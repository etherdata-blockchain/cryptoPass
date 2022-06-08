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
    static let rpc = ProcessInfo.processInfo.environment["RPC"]
    static let contractAddress = ProcessInfo.processInfo.environment["CONTRACT_ADDRESS"]
}
