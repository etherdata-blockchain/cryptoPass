//
//  TransactionStatus+extension.swift
//  cryptoPass (iOS)
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3

extension EthereumTransactionReceiptStatus{
    func toString() -> String{
        switch self{
        case .success: return "success"
        case .failure: return "failure"
        case .notProcessed: return "not Processed"
            
        }
    }
}
