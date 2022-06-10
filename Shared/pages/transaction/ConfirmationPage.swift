//
//  Confirm.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI
import web3
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
    @State private var err: TransacionError?
    @State private var showError = false
    @State private var selection: Routes?
    @State private var chainId: Int?
    
    
    var body: some View {
        NavigationView {
            VStack{
                if let transactionId = transactionModel.transactionId{
                    NavigationLink(destination: TransactionDetail(transactionHash: transactionId, fromConfirmation: true), tag: Routes.showTransactionPage, selection: $selection){
                        
                    }
                }
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
                                    Text("\(gasPrice!.toString()) gwei")
                                }
                            }
                            
                            FormTextField(leading: {Text("Nonce")}){
                                LoadingView(isLoading: nonce == nil) {
                                    Text("\(nonce!)")
                                }
                            }
                            
                            
                            FormTextField(leading: {Text("ChainID")}){
                                LoadingView(isLoading: chainId == nil) {
                                    Text("\(chainId!)")
                                }
                            }
                        }
                        
                        Section("Status"){
                            FormTextField(leading: { Text("Transaction Status") }){
                                Text(transactionModel.transactionStatus.rawValue)
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
                        self.transactionModel.closeConfirmation()
                    }
                }
            }
            .navigationTitle(Text("Confirmation"))
            .toolbar{
                Button {
                    transactionModel.closeConfirmation()
                } label: {
                    Text("Close")
                }

            }
            .interactiveDismissDisabled(true)
            .task {
                await fetchChainData()
            }
            .alert(isPresented: $showError, error: err) {
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
                        do{
                            try await transactionModel.sendTransaction(with: ethereumModel.ethereumClient, account: userAccountModel.userAccount!)
                            selection = Routes.showTransactionPage
                        } catch let error as TransacionError {
                            self.err = error
                            self.showError = true
                        }
                    }
                    
                    
                }
                
                if !authenticated{
                    if hasError{
                        showError = true
                        err = TransacionError.invalidDevice
                    } else {
                        err = TransacionError.authenticationError
                    }
                }
            }
        }
    }
    
    
    private func fetchChainData() async {
        withAnimation{
            Task {
                if let transaction =  transactionModel.transaction{
                    do {
                        gasFee = try await ethereumModel.ethereumClient.eth_estimateGas(transaction, withAccount: userAccountModel.userAccount!)
                        gasPrice = try await ethereumModel.ethereumClient.eth_gasPrice()
                        nonce = try await ethereumModel.ethereumClient.eth_getTransactionCount(address: userAccountModel.userAccount!.address, block: .Latest)
                        chainId = try await ethereumModel.ethereumClient.chainId()
                        
                        transactionModel.updateTransaction(chainId: chainId!, gasPrice: gasPrice!, gasLimit: 2100000, nonce: nonce!)
                    } catch{
                        
                    }
                }
            }
        }
    }
}
