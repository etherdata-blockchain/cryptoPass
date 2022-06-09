//
//  TransactionModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3

class TransactionModel: ObservableObject{
    @Published var showConfirmationDialog: Bool = false
    @Published var transaction: EthereumTransaction? = nil
    
    func show(transaction: EthereumTransaction){
        showConfirmationDialog = true
        self.transaction = transaction
    }
    
    func close(){
        showConfirmationDialog = false
        transaction = nil
    }
}
