//
//  Tests_EthereumKeyStorage.swift
//  Tests Shared
//
//  Created by Qiwei Li on 6/10/22.
//

import XCTest
@testable import cryptoPass
@testable import web3

class Tests_EthereumKeyStorage: XCTestCase {
    let provider = cryptoPass.EthereumKeyChainStorage()
    let privateKey = "047a270495c0cebc7997c5e561c69827a7e431673338e7fbb1c50450eb6b0a67"
    let address = "0x5bFE669322547437d4447a861763d5Ab316358e7"

    func testStorePassword() throws{
        try provider.storePrivateKey(key: privateKey.data(using: .utf8)!)
        let storedPrivateKey = try provider.loadPrivateKey()
        let storedStringPrivateKey = storedPrivateKey.web3.hexString
        XCTAssertEqual(storedStringPrivateKey, "0x\(privateKey)")
        
        let account = try web3.EthereumAccount.importAccount(keyStorage: provider, privateKey: privateKey)
        let loadedAccount = try web3.EthereumAccount.init(keyStorage: provider)
        XCTAssertEqual(account.address.value, loadedAccount.address.value)
        XCTAssertEqual(loadedAccount.address.value.lowercased(), address.lowercased())
    }
    
    func testStorePassword2() throws{
        let account = try web3.EthereumAccount.create(keyStorage: provider, keystorePassword: "123")
        let loadedAccount = try EthereumAccount(keyStorage: provider, keystorePassword: "123")
        XCTAssertEqual(account.address.value, loadedAccount.address.value)
    }
}
