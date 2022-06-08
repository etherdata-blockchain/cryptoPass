//
//  BigInt+extension.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation
import BigInt

extension BigInt{
    func toETD() -> Double{
        Double(self) / pow(10, 18)
    }
}
