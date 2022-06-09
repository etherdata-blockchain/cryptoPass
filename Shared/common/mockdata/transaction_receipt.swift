//
//  transaction_receipt.swift
//  cryptoPass (iOS)
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import web3


struct TransactionReceiptDataProvider{
    static func getRceiptData() -> EthereumTransactionReceipt{
        let transaction_receipt = [
            "blockHash": "0x78be0dc04c20df0216df129eb6bd8922b827ffd311e89bb32cdd366d63a1be23",
            "blockNumber": "0x2c18",
            "cumulativeGasUsed": "0x3871e",
            "effectiveGasPrice": "0x3b9aca00",
            "from": "0xe48a7c0849bc39f81e4becfa8535b0ab74af1355",
            "gasUsed": "0x3871e",
            "logs": [],
            "logsBloom": "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
            "status": "0x1",
            "to": "0x5589779ccfc867ad8cd60680dfd570da55cd451e",
            "transactionHash": "0xe7dd3850731931686ef90436b90ca23159695fd54015f840ae63389aff14f230",
            "transactionIndex": "0x0",
            "type": "0x0"
        ] as [String : Any]
        
        let transaction_receipt_json = try! JSONSerialization.data(withJSONObject: transaction_receipt)
        return try! JSONDecoder().decode(EthereumTransactionReceipt.self, from: transaction_receipt_json)
        
    }
}
