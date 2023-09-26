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
    
    public var index: BigUInt
    
    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                index: BigUInt) {
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
    
    var start: BigUInt
    var end: BigUInt
    
    public init(contract: EthereumAddress,
                from: EthereumAddress? = nil,
                start: BigUInt, end: BigUInt) {
        
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

struct GetSecretsInRangeResponse: ABIResponse {
    public static var types: [ABIType.Type] = [ String.self ]
    public let value: [String]
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {
        self.value = try values[0].decodedArray()
    }
}

struct GetSecretSizeResponse: ABIResponse {
    public static var types: [ABIType.Type] = [ BigUInt.self ]
    public let value: BigUInt
    
    public init?(values: [ABIDecoder.DecodedValue]) throws {
        self.value = try values[0].decoded()
    }
}



struct CryptoPass{
    let contractAddress = EthereumAddress(Environments.contractAddress)
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
     Returns secret size
     */
    func getSecretSize() async throws -> BigUInt{
        let function = GetSecretSize(contract: contractAddress, from: account.address)
        let size = try await function.call(withClient: client, responseType: GetSecretSizeResponse.self).value
        print("Size: \(size)")
        return size
    }
    
    /**
     Get lis of secrets in range. Secret will be website, payment card or bank
     */
    func getSecretsInRange(start: BigUInt, end: BigUInt) async throws -> [Any]{
        let function = GetSecretInRange(contract: contractAddress, from: account.address, start: start, end: end)
        let transaction = try! function.transaction()
        let result = try await client.eth_call(transaction)
        let decodeData = try ABIDecoder.decodeData(result, types: [ABIArray<String>.self], asArray: true)
        let secrets = try GetSecretsInRangeResponse(values: decodeData)?.value
        if let secrets = secrets{
            let decodedSecrets: [Data?] = secrets.map { message -> Data? in
                self.decode(message: message)
            }
            
            let decodedFilteredSecrets: [Data] = decodedSecrets.compactMap{$0}
            let decodedPasswords = try decodedFilteredSecrets.map { data -> Any? in
                let basePassword = try? JSONDecoder().decode(BasePassword.self, from: data)
                switch (basePassword?.type){
                case .website:
                    return try JSONDecoder().decode(WebsitePassword.self, from : data)
                case .paymentCard:
                    return try JSONDecoder().decode(PaymentCardPassword.self, from : data)
                case .bank:
                    return try JSONDecoder().decode(BankPassword.self, from : data)
                case .none:
                    return nil
                }
            }
            return decodedPasswords.compactMap{$0}
        }
       
        return []
    }
    
    func prepareDeleteTransaction(at index: BigUInt) async throws -> EthereumTransaction{
        let function = DeleteSecret(contract: contractAddress, index: index)
        let transaction = try function.transaction()
        return transaction
    }
}
