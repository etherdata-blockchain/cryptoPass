//
//  ethereumClient+extension.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3

extension EthereumClient{
    func chainId() async throws -> Int{
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Int, Error>) in
            let emptyParams: Array<Bool> = []
            EthereumRPC.execute(session: session, url: url, method: "eth_chainId", params: emptyParams, receive: String.self) { (error, response) in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                
                if let hexString = response as? String{
                    if let chainId = Int(hex: hexString){
                        continuation.resume(returning: chainId)
                    } else {
                        continuation.resume(throwing: EthereumClientError.unexpectedReturnValue)
                    }
                } else {
                    continuation.resume(throwing: EthereumClientError.unexpectedReturnValue)
                }
            }
        }
    }
}
