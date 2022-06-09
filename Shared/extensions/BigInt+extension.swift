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

extension BigUInt{
    func toETD() -> Double{
        Double(self) / pow(10, 18)
    }
    
    func toString() -> String{
       String( Double(self))
    }
}

extension Double{
    func toSwiftUIString() -> String{
        String(format: "%.2f", self)
    }
}
