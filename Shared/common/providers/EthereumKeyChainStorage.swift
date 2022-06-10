//
//  KeyChainProvider.swift
//  cryptoPass (iOS)
//
//  Created by Qiwei Li on 6/10/22.
//

import Foundation
import web3
import Valet

/**
 Store ethereum private key in keychain
 */
class EthereumKeyChainStorage: EthereumKeyStorageProtocol{
    let valet = Valet.valet(with: Identifier(nonEmpty: KeyName.keychainName.rawValue)!, accessibility: .afterFirstUnlock)
    
    func storePrivateKey(key: Data) throws -> Void{
        do {
            let stringData = String(decoding: key, as: UTF8.self)
            try valet.setString(stringData, forKey: KeyName.privateKeyName.rawValue)
        } catch KeychainError.missingEntitlement {
            throw PrivateKeyError.cannotStorePrivateKey
        } catch EthereumAccountError.importAccountError {
            throw PrivateKeyError.invalidPrivateKey
        }
    }
       
    
    func loadPrivateKey() throws -> Data{
        do {
            let stringData = try valet.string(forKey: KeyName.privateKeyName.rawValue)
            if let data = stringData.web3.hexData{
                // loading not encrypted data
                return data
            }
            
            // loading encrypted data
            if let data = stringData.data(using: .utf8){
                return data
            }
            throw PrivateKeyError.invalidPrivateKey
        } catch KeychainError.itemNotFound{
            throw PrivateKeyError.privateKeyNotFound
        }
    }
}
