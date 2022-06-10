//
//  LoginError.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/10/22.
//

import Foundation

enum AuthenticationError: LocalizedError, Identifiable{
    case invalidIdentity
    case invalidDevice
    
    
    var id: String {localizedDescription}
    
    var errorDescription: String? {
        switch self {
        case .invalidDevice: return "Device doesn't support FaceID or Touch ID"
        case .invalidIdentity: return "Authentication failed"
        }
    }
}
