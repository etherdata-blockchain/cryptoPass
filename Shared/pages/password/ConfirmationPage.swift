//
//  Confirm.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI
import web3
import CryptoSwift
import BigInt
import LocalAuthentication


struct ConfirmationPage: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    @EnvironmentObject var transactionModel: TransactionModel
    @EnvironmentObject var authenticationModel: AuthenticationModel
    @EnvironmentObject var ethereumModel: EthereumModel

    @State private var gasPrice: BigUInt?
    @State private var gasFee: BigUInt?
    @State private var nonce: Int?
    @State private var error: TransacionError?
    @State private var showError = false
    
    
    var body: some View {
        NavigationView {
            VStack{
                if let transaction = transaction {
                    Form{
                        Section("Transaction Summary") {
                            FormTextField(leading: {Text("Value")}) {
                                Text("\(transactionModel.transaction?.value?.toETD() ?? 0) ETD")
                            }
                            FormTextField(leading: {Text("Estimate Gas")}){
                                LoadingView(isLoading: gasFee == nil) {
                                    Text("\(gasFee!.toString()) gwei")
                                }
                            }
                            
                            FormTextField(leading: {Text("Gas Price")}){
                                LoadingView(isLoading: gasPrice == nil) {
                                    Text("\(gasPrice!.toETD()) ETD")
                                }
                            }
                            
                            FormTextField(leading: {Text("Nonce")}){
                                LoadingView(isLoading: nonce == nil) {
                                    Text("\(nonce!)")
                                }
                            }
                        }
                    }
                    FilledButton(color: .indigo, title: "Confirm", isLoading: nil) {
                        onConfirm()
                    }
                } else {
                    VStack{
                        Spacer()
                        Text("Transaction initializing error")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    Spacer()
                    FilledButton(color: .indigo, title: "Close", isLoading: nil) {
                        self.transactionModel.close()
                    }
                }
            }
            .navigationTitle(Text("Confirmation"))
            .toolbar{
                Button {
                    transactionModel.close()
                } label: {
                    Text("Close")
                }

            }
            .interactiveDismissDisabled(true)
            .task {
                await fetchGasFee()
            }
            .alert(isPresented: $showError, error: error) {
                Button(action: {showError = false}) {
                    Text("Close")
                }
        }
        }
    }
    
    
    private func onConfirm(){
        self.authenticationModel.authenticate { authenticated, hasError in
            DispatchQueue.main.async {
                if authenticated{
                    /// make a transaction
                    Task{
                        let transactionID = try await ethereumModel.ethereumClient.eth_sendRawTransaction(self.transactionModel.transaction!, withAccount: userAccountModel.userAccount!)
                        print("Transaction ID: \(transactionID)")
                        self.transactionModel.close()
                    }
                    
                    
                }
                
                if !authenticated{
                    if hasError{
                        showError = true
                        error = TransacionError.invalidDevice
                    } else {
                        error = TransacionError.authenticationError
                    }
                }
            }
        }
    }
    
    
    private func fetchGasFee() async {
        withAnimation{
            Task {
                if let transaction =  transactionModel.transaction{
                    do {
                        gasFee = try await ethereumModel.ethereumClient.eth_estimateGas(transaction, withAccount: userAccountModel.userAccount!)
                        gasPrice = try await ethereumModel.ethereumClient.eth_gasPrice()
                        nonce = try await ethereumModel.ethereumClient.eth_getTransactionCount(address: userAccountModel.userAccount!.address, block: .Latest)
                    } catch{
                        
                    }
                }
            }
        }
    }
}
