//
//  TransactionDetail.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI

struct TransactionDetail: View {
    @EnvironmentObject var transactionModel: TransactionModel
    @EnvironmentObject var ethereumModel: EthereumModel
    
    @State private var error: String?
    
    let transactionHash: String
    var fromConfirmation = false
    let timer = Timer.publish(every: Config.autoRefreshInterval, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Form{
            TransactionDetailView(transaction: transactionModel.transactionReceipt)
        }
        .onReceive(timer){ timer in
            Task{
                if transactionModel.transactionReceipt?.status != .success || transactionModel.transactionReceipt?.status != .notProcessed{
                    try? await transactionModel.getTransactionReceipt(with: ethereumModel.ethereumClient, txHash: transactionHash)
                }
              
            }
        }
        .navigationTitle(Text("Transaction Detail"))
        .toolbar{
            if fromConfirmation{
                Button {
                    transactionModel.closeConfirmation()
                } label: {
                    Text("Close")
                }
            }
        }
        .task {
            try? await transactionModel.getTransactionReceipt(with: ethereumModel.ethereumClient, txHash: transactionHash)
            
        }
    }
}
