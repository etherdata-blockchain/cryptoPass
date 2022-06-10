//
//  TransactionModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3
import BigInt

class TransactionModel: ObservableObject{
    @Published var showConfirmationDialog: Bool = false
    @Published var transaction: EthereumTransaction? = nil
    @Published var transactionStatus: TransactionStatusEnum = .confirming
    @Published var transactionId: String?
    @Published var transactionReceipt: EthereumTransactionReceipt?
    
    func updateTransaction(chainId: Int, gasPrice: BigUInt, gasLimit: BigUInt, nonce: Int){
        if let transaction = transaction {
            let newTransaction = EthereumTransaction(from: transaction.from, to: transaction.to, value: transaction.value, data: transaction.data, nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, chainId: chainId)
            self.transaction = newTransaction
        }
    }
    
    @MainActor
    func getTransactionReceipt(with client: EthereumClient, txHash: String)async throws{
        transactionReceipt = try await client.eth_getTransactionReceipt(txHash: txHash)
    }
    
    /**
     Send transaction with ethereum client and user account
     */
    @MainActor
    func sendTransaction(with client: EthereumClient, account: EthereumAccount)async throws{
        if let transaction = transaction {
            if transactionStatus == .confirming || transactionStatus == .failed {
                transactionStatus = .sending
                do {
                    transactionId = try await client.eth_sendRawTransaction(transaction, withAccount: account)
                    transactionStatus = .sent
                }
                catch{
                    transactionStatus = .failed
                    throw TransacionError.failedSendingTransaction
                }
            } else {
                throw TransacionError.invalidTransactionStatus
            }
        } else {
            throw TransacionError.noTransaction
        }
    }
    
    func showConfirmation(transaction: EthereumTransaction){
        showConfirmationDialog = true
        self.transaction = transaction
    }
    
    func closeConfirmation(){
        showConfirmationDialog = false
        transaction = nil
        self.transactionId = nil
        self.transactionStatus = .confirming
        self.transactionReceipt = nil
    }
}
