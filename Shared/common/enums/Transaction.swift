//
//  Transaction.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation

enum TransactionStatusEnum: String{
    case confirming = "Confirming"
    case sending = "Sending"
    case sent = "Sent"
    case failed = "Failed"
}
