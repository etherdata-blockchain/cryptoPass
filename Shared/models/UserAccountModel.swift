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
    @Published var shouldInitAccount = false
    @Published var privateKey: Data?
    private let storage = EthereumKeyChainStorage()
    
    func initialize(){
        do {
            privateKey = try storage.loadPrivateKey()
            userAccount = try EthereumAccount.init(keyStorage: storage)
            shouldInitAccount = false
            hasInitAccount = true
        } catch EthereumKeyStorageError.failedToLoad {
            shouldInitAccount = true
            print("No previous stored private key")
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func importAccount(privateKey: String) throws{
        let keyStoreage = EthereumKeyChainStorage()
        //TODO: Replace 123
        userAccount = try EthereumAccount.importAccount(keyStorage: keyStoreage, privateKey: privateKey)
        self.privateKey = privateKey.web3.hexData
    }
    
    func resetAccount(){
        userAccount = nil
        hasInitAccount = false
        shouldInitAccount = true
    }
    
    func finishSetup(){
        hasInitAccount = true
        shouldInitAccount = false
    }
}
