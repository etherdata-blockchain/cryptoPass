//
//  cryptoPassContract.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation
import BigInt
import web3


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
    
    func addSecret(secret: String) async throws {
        let function = AddSecret(contract: contractAddress, secret: secret)
        let transaction = try function.transaction()
        let _ = try await client.eth_sendRawTransaction(transaction, withAccount: account)
    }
    
    func getSecretSize() async throws -> BigInt{
        let function = GetSecretSize(contract: contractAddress)
        let result = try await function.call(withClient: client, responseType: GetSecretSizeResponse.self)
        return result.value
    }
    
    func getSecretsInRange(start: BigInt, end: BigInt) async throws -> [String]{
        let function = GetSecretSize(contract: contractAddress)
        let result = try await function.call(withClient: client, responseType: GetSecretsInRangeResponse.self)
        return result.value
    }
}
