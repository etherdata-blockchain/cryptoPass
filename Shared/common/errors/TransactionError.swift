//
//  TransactionError.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation

enum TransacionError: LocalizedError, Identifiable{
    case authenticationError
    case invalidDevice
    case invalidTransactionStatus
    case noTransaction
    case failedSendingTransaction
    
    var id: String {localizedDescription}
    
    var errorDescription: String? {
        switch self {
        case .authenticationError: return "Cannot verify your identity"
        case .invalidDevice: return "Your device doesn't have a local authentication device"
        case .invalidTransactionStatus: return "Transaction is not in confirming stage"
        case .noTransaction: return "No transaction"
        case .failedSendingTransaction: return "Cannot send transaction"
        }
    }
}
