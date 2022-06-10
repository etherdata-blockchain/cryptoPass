//
//  CryptoPassModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation
import web3


class CryptoPassModel : ObservableObject{
    @Published var client: CryptoPass?
    
    func setUp(client: EthereumClient, account: EthereumAccount, privateKey: Data){
        print("Setting up account: \(privateKey.web3.hexString)")
        self.client = CryptoPass(client: client, account: account, privateKey: privateKey)
    }
}
