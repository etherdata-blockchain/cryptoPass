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
    @Published var privateKey: Data?
    
    init(){
        let storage = EthereumKeyLocalStorage()
        do {
            privateKey = try storage.loadAndDecryptPrivateKey(keystorePassword: "123")
            //TODO: Replace 123
            userAccount = try EthereumAccount.init(keyStorage: storage, keystorePassword: "123")
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
    
    func setUpAccount(_ account: EthereumAccount, privateKey: Data){
        self.privateKey = privateKey
        userAccount = account
        hasInitAccount = true
        shouldInitAccount = false
    }
}
