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
    
    @State private var isLoading = false
    @State private var blockNumber: Int?
    @State private var accountBalance: BigInt?
    @State private var hasError = false
    @State private var error: String?
    
    let timer = Timer.publish(every: Config.autoRefreshInterval, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group{
            if (isLoading){
                ProgressView()
            } else {
                List{
                    Section(header: Text("Blockchain info")) {
                        InfoCard(title: "BlockNumber", subtitle: "\(blockNumber ?? 0)", color: .orange, unit: "blocks", icon: .boltBatteryblock)
                        
                        InfoCard(title: "Balance", subtitle: "\((accountBalance ?? 0).toETD())", color: .orange, unit: "ETD", icon: .boltBatteryblock)
                    }
                    
                    Section(header: Text("Passwords")) {
                        
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
            task {
                await fetchBlockchainData()
            }
        }
        .alert(isPresented: $hasError){
            Alert(title: Text("Error"), message: Text(error!), dismissButton: .default(Text("ok")))
        }
        .task {
            await fetchBlockchainData()
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
                    print("Address: \(userAccountModel.userAccount!.address)")
                    blockNumber = try await userAccountModel.ethereumClient.eth_blockNumber()
                    accountBalance = BigInt(try await userAccountModel.ethereumClient.eth_getBalance(address: userAccountModel.userAccount!.address, block: EthereumBlock.Latest))
                    
                    if let cryptoPass = userAccountModel.cryptoPass{
                        let secretSize = try await cryptoPass.getSecretSize()
                        if secretSize > 0{
                            let secrets = try await cryptoPass.getSecretsInRange(start: 0, end: secretSize)
                            print(secrets)
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
