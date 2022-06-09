//
//  TransactionDetailView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI
import web3

struct TransactionDetailView: View {
    let transaction: EthereumTransactionReceipt?
    
    var body: some View {
        Group{
            Section(header: Text("Block Details")) {
                FormTextField {
                    Text("Transaction")
                } trailing: {
                    LoadingView(isLoading: transaction == nil) {
                        Text(transaction!.transactionHash)
                    }
                }
                
                FormTextField {
                    Text("Block Number")
                } trailing: {
                    LoadingView(isLoading: transaction == nil) {
                        if let blockNumber = transaction?.blockNumber{
                            Text("\(blockNumber.toString())")
                        }
                    }
                }
                
                FormTextField {
                    Text("Block hash")
                } trailing: {
                    LoadingView(isLoading: transaction == nil) {
                        if let blockHash = transaction?.blockHash{
                            Text("\(blockHash)")
                        }
                    }
                }
                
                FormTextField {
                    Text("Gas Used")
                } trailing: {
                    LoadingView(isLoading: transaction == nil) {
                        Text("\(transaction!.gasUsed.toString()) gwei")
                    }
                }
            }
            
            Section(header: Text("Status")) {
                FormTextField {
                    Text("Status")
                } trailing: {
                    LoadingView(isLoading: transaction == nil) {
                        Text("\(transaction!.status.toString())")
                    }
                }
            }
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Form{
            TransactionDetailView(transaction: TransactionReceiptDataProvider.getRceiptData())
        }
    }
}
