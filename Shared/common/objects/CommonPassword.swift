//
//  CommonPassword.swift
//  cryptoPass (iOS)
//
//  Created by Qiwei Li on 6/9/22.
//

import Foundation

struct CommonPassword: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let type: PasswordType
    
    static func from(password: Any) -> CommonPassword?{
        if let password = password as? WebsitePassword{
            return CommonPassword(name: password.name, description: password.description, type: password.type)
        }
        
        if let password = password as? PaymentCardPassword{
            return CommonPassword(name: password.name, description: password.description, type: password.type)
        }
        
        if let password = password as? BankPassword{
            return CommonPassword(name: password.name, description: password.description, type: password.type)
        }
        
        return nil
    }
}
