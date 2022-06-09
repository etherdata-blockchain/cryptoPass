//
//  cryptoPassContract.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation
import BigInt
import web3
import CryptoKit

private struct AddSecret: ABIFunction{
    public var gasPrice: BigUInt? = nil
    
    public var gasLimit: BigUInt? = nil
    
    public var contract: EthereumAddress
    
    public var from: EthereumAddress?
    
    public static var name: String = "addSecret"
    
    public var secret: String
    
    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                secret: String) {
        self.contract = contract
        self.from = from
        self.secret = secret
    }
    
    public func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(secret)
    }
}


private struct DeleteSecret: ABIFunction{
    var gasPrice: BigUInt?
    
    var gasLimit: BigUInt?
    
    var contract: EthereumAddress
    
    var from: EthereumAddress?
    
    static var name: String = "deleteFile"
    
    public var index: BigInt
    
    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                index: BigInt) {
        self.contract = contract
        self.from = from
        self.index = index
    }
    
    
    func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(self.index)
    }
    
    
}


private struct GetSecretInRange: ABIFunction{
    var gasPrice: BigUInt?
    
    var gasLimit: BigUInt?
    
    var contract: EthereumAddress
    
    var from: EthereumAddress?
    
    static var name: String = "getSecretInRange"
    
    var start: BigInt
    var end: BigInt
    
    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                start: BigInt, end: BigInt) {
        
        self.contract = contract
        self.from = from
        self.start = start
        self.end = end
    }
    
    func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(start)
        try encoder.encode(end)
    }
}


private struct GetSecretSize: ABIFunction{
    var gasPrice: BigUInt?
    
    var gasLimit: BigUInt?
    
    var contract: EthereumAddress
    
    var from: EthereumAddress?
    
    static var name: String = "getSecretSize"
    
    func encode(to encoder: ABIFunctionEncoder) throws {
        
    }
}

struct GetSecretSizeResponse: ABIResponse {
    public static var types: [ABIType.Type] = [ BigInt.self ]
    public let value: BigInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {
        self.value = try values[0].decoded()
    }
}

struct GetSecretsInRangeResponse: ABIResponse {
    public static var types: [ABIType.Type] = [ String.self ]
    public let value: [String]
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {
        self.value = try values[0].decodedArray()
    }
}

struct CryptoPass{
    let contractAddress = EthereumAddress(Environments.contractAddress!)
    let client: EthereumClient
    let account: EthereumAccount
    let privateKey: Data
    
    private func decode(message: String) -> Data?{
        if let combinedData = Data(base64Encoded: message){
            do {
                let newBox = try AES.GCM.SealedBox.init(combined: combinedData)
                let originalData = try AES.GCM.open(newBox, using: privateKey.getSymmetricKey())
                return originalData
            } catch {
                print("Cannot decode message \(message) due to \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    func prepareAddSecret(secret: Data) throws -> EthereumTransaction?{
        let sealedBox = try AES.GCM.seal(secret, using: privateKey.getSymmetricKey())
        if let sealedSecret = sealedBox.combined?.base64EncodedString(){
            let function = AddSecret(contract: contractAddress, secret: sealedSecret)
            let transaction = try function.transaction()
            return transaction
        }
        return nil
    }

    /**
     Add a new secret. Will return the transaction id
     */
    func addSecret(secret: Data) async throws -> String? {
        if let transaction = try prepareAddSecret(secret: secret){
            let transactionHash = try await client.eth_sendRawTransaction(transaction, withAccount: account)
            return transactionHash
        }
        return nil
    }
    
    /**
     Returns secret size
     */
    func getSecretSize() async throws -> BigInt{
        let function = GetSecretSize(contract: contractAddress)
        let result = try await function.call(withClient: client, responseType: GetSecretSizeResponse.self)
        return result.value
    }
    
    /**
     Get lis of secrets in range. Secret will be website, payment card or bank
     */
    func getSecretsInRange(start: BigInt, end: BigInt) async throws -> [Any?]{
        let function = GetSecretSize(contract: contractAddress)
        let result = try await function.call(withClient: client, responseType: GetSecretsInRangeResponse.self)
        let secrets: [Any?] = try result.value.map { message in
            self.decode(message: message)
        }.filter { data in
            data != nil
        }.map { data in
            let basePassword = try? JSONDecoder().decode(BasePassword.self, from: data!)
            switch (basePassword?.type){
            case .website:
                return try JSONDecoder().decode(WebsitePassword.self, from : data!)
            case .paymentCard:
                return try JSONDecoder().decode(PaymentCardPassword.self, from : data!)
            case .bank:
                return try JSONDecoder().decode(BankPassword.self, from : data!)
            case .none:
                return nil
            }
        }
        return secrets
    }
}
