//
//  Data+extension.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation
import CryptoKit

extension Data{
    func getSymmetricKey() -> SymmetricKey{
        let pass = SHA256.hash(data: self)
        return SymmetricKey(data: pass)
    }
}
