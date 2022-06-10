//
//  EthereumAccount+extension.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/10/22.
//

import Foundation
import web3


extension EthereumAccount{
    static func importAccount(keyStorage: EthereumKeyStorageProtocol, privateKey: String) throws -> EthereumAccount{
        guard let privateKey = privateKey.data(using: .utf8) else {
            throw EthereumAccountError.importAccountError
        }
        do {
            try keyStorage.storePrivateKey(key: privateKey)
            return try self.init(keyStorage: keyStorage)
        } catch {
            throw EthereumAccountError.importAccountError
        }
    }
}
