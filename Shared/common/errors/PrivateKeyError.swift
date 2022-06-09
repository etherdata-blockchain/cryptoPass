//
//  PrivateKeyError.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation


enum PrivateKeyError: LocalizedError, Identifiable{
    case emptyPrivateKey
    case invalidPrivateKey
    
    var id: String {localizedDescription}
    
    var errorDescription: String?{
        switch (self){
        case .emptyPrivateKey: return "Private key should not be empty"
        case .invalidPrivateKey: return "Invalid private key"
        }
    }
}
