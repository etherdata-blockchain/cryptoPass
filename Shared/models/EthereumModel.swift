//
//  EthereumModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3

class EthereumModel: ObservableObject{
    @Published var ethereumClient: EthereumClient
    
    init(){
        let clientUrl = URL(string: Environments.rpc!)
        self.ethereumClient = EthereumClient(url: clientUrl!)
    }
}
