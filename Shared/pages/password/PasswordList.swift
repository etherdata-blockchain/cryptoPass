//
//  PasswordList.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import web3
import BigInt

struct PasswordList: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    @EnvironmentObject var cryptoPassModel: CryptoPassModel
    @EnvironmentObject var ethereumModel: EthereumModel
    @EnvironmentObject var transactionModel: TransactionModel
    
    @State private var isLoading = false
    @State private var blockNumber: Int?
    @State private var accountBalance: BigInt?
    @State private var hasError = false
    @State private var error: String?
    @State private var selection: Int?
    @State private var passwords: [CommonPassword] = []
    
    let timer = Timer.publish(every: Config.autoRefreshInterval, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group{
            NavigationLink(destination:  PasswordForm(), tag: 1, selection: $selection){
                
            }
            List{
                Section(header: Text("Blockchain info")) {
                    InfoCard(title: "BlockNumber", subtitle: "\(blockNumber ?? 0)", color: .orange, unit: "blocks", icon: .boltBatteryblock)
                    
                    InfoCard(title: "Balance", subtitle: "\((accountBalance ?? 0).toETD())", color: .orange, unit: "ETD", icon: .boltBatteryblock)
                }
                
                
                Section(header: Text("Passwords")) {
                    ForEach(passwords){ password in
                        PasswordRow(password: password)
                    }
                    .onDelete{
                        indexSet in
                        Task{
                            await delete(at: indexSet)
                        }
                    }
                    
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: { userAccountModel.resetAccount() }){
                        Image(systemSymbol: .externaldriveFill)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: { selection = 1 }){
                        Image(systemSymbol: .plus)
                    }
                }
            }
            
            
        }
        .navigationTitle(Text("Password"))
        .refreshable {
            await fetchBlockchainData(isRefresh: true)
        }
        .onReceive(timer){
            timer in
            Task {
//                await fetchBlockchainData()
            }
        }
        .onReceive(userAccountModel.$userAccount){ _ in
            Task {
                await fetchBlockchainData()
            }
        }
        .onReceive(transactionModel.$transactionReceipt){
            _ in
            Task {
                await fetchBlockchainData()
            }
        }
        .alert(isPresented: $hasError){
            Alert(title: Text("Error"), message: Text(error!), dismissButton: .default(Text("ok")))
        }
        .task {
            await fetchBlockchainData()
        }
        .sheet(isPresented: $transactionModel.showConfirmationDialog) {
            ConfirmationPage()
        }
    }
    
    func delete(at offsets: IndexSet) async {
        let index = offsets.first
        if let cryptoPass = cryptoPassModel.client{
            if let index = index {
                let transaction = try! await cryptoPass.prepareDeleteTransaction(at: BigUInt(index))
                transactionModel.showConfirmation(transaction: transaction)
            }
        }
    }
    
    /**
     Fetch number of blocks, account balance and list of passwords
     */
    private func fetchBlockchainData(isRefresh: Bool = false) async {
        withAnimation{
            Task{
                do{
                    if !isRefresh {
                        isLoading = true
                    }
                    blockNumber = try await ethereumModel.ethereumClient.eth_blockNumber()
                    accountBalance = BigInt(try await ethereumModel.ethereumClient.eth_getBalance(address: userAccountModel.userAccount!.address, block: EthereumBlock.Latest))
                    
                    if let cryptoPass = cryptoPassModel.client{
                        let passwordSize = try await cryptoPass.getSecretSize()
                        if passwordSize > 0{
                            passwords = try await cryptoPass.getSecretsInRange(start: 0, end: passwordSize).map{
                                password in
                                CommonPassword.from(password: password)!
                            }
                        }
                    }
                    
                } catch{
                    print(error.localizedDescription)
                    hasError = true
                    self.error = error.localizedDescription
                }
                isLoading = false
            }
        }
    }
}

struct PasswordList_Previews: PreviewProvider {
    static var previews: some View {
        PasswordList()
    }
}
