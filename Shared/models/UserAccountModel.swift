//
//  UserAccountModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation
import web3


class UserAccountModel: ObservableObject{
    @Published var userAccount: EthereumAccount?
    @Published var hasInitAccount: Bool = false
    @Published var shouldInitAccount = true
    @Published var ethereumClient: EthereumClient
    @Published var cryptoPass: CryptoPass?
    
    init(){
        let storage = EthereumKeyLocalStorage()
        let clientUrl = URL(string: Environments.rpc!)
        self.ethereumClient = EthereumClient(url: clientUrl!)
        do {
            let _ = try storage.loadPrivateKey()
            //TODO: Replace 123
            userAccount = try EthereumAccount.init(keyStorage: storage, keystorePassword: "123")
            cryptoPass = CryptoPass(client: ethereumClient, account: userAccount!)
            shouldInitAccount = false
            hasInitAccount = true
        } catch EthereumKeyStorageError.failedToLoad {
            print("No previous stored private key")
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func resetAccount(){
        userAccount = nil
        hasInitAccount = false
        shouldInitAccount = true
    }
    
    func setUpAccount(_ account: EthereumAccount){
        userAccount = account
        hasInitAccount = true
        shouldInitAccount = false
        cryptoPass = CryptoPass(client: ethereumClient, account: account)
    }
}
