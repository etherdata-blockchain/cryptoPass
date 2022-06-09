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
    @EnvironmentObject var passwordListModel: PasswordListModel
    

    
    var body: some View {
        Group{
            NavigationLink(destination:  PasswordForm(), tag: 1, selection: $passwordListModel.selection){
                
            }
            List{
                Section(header: Text("Blockchain info")) {
                    InfoCard(title: "BlockNumber", subtitle: "\(passwordListModel.blockNumber)", color: .orange, unit: "blocks", icon: .boltBatteryblock)
                    
                    InfoCard(title: "Balance", subtitle: "\(passwordListModel.accountBalance.toETD().toSwiftUIString())", color: .orange, unit: "ETD", icon: .boltBatteryblock)
                    
                    InfoCard(title: "Password Count", subtitle: "\(passwordListModel.passwordSize)", color: .orange, unit: "", icon: .boltBatteryblock)
                }
                
                
                Section(header: Text("Passwords")) {
                    ForEach(passwordListModel.passwords){ password in
                        NavigationLink(destination: PasswordForm(editMode: false, password: password)) {
                            PasswordRow(password: password)
                        }
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
                    Button(action: { passwordListModel.selection = 1 }){
                        Image(systemSymbol: .plus)
                    }
                }
            }
            
            
        }
        .navigationTitle(Text("Password"))
        .refreshable {
            print("BlockNumber: \(passwordListModel.blockNumber)")
            await fetchBlockchainData(isRefresh: true)
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
        .alert(isPresented: $passwordListModel.hasError){
            Alert(title: Text("Error"), message: Text(passwordListModel.error!), dismissButton: .default(Text("ok")))
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
        passwordListModel.update()
        withAnimation{
            Task{
                do{
                    if let userAccount = userAccountModel.userAccount{
                        passwordListModel.blockNumber = try await ethereumModel.ethereumClient.eth_blockNumber()
                        passwordListModel.accountBalance = BigInt(try await ethereumModel.ethereumClient.eth_getBalance(address: userAccount.address, block: EthereumBlock.Latest))
                        
                        if let cryptoPass = cryptoPassModel.client{
                            passwordListModel.passwordSize = try await cryptoPass.getSecretSize()
                            if passwordListModel.passwordSize > 0{
                                passwordListModel.passwords = try await cryptoPass.getSecretsInRange(start: 0, end: passwordListModel.passwordSize).map{
                                    password in
                                    CommonPassword.from(password: password)!
                                }
                            } else {
                                passwordListModel.passwords = []
                            }
                        }
                    }
                    
                } catch{
                    print(error.localizedDescription)
                    passwordListModel.hasError = true
                    passwordListModel.error = error.localizedDescription
                }
            }
        }
    }
}

struct PasswordList_Previews: PreviewProvider {
    static var previews: some View {
        PasswordList()
    }
}
