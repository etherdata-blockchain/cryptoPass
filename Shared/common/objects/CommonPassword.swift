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
    let password: String
    let type: PasswordType
    let originPassword: Any
    
    func toBasePassword() -> BasePassword {
        return BasePassword(name: self.name, description: self.description, password: self.password, type: self.type)
    }
    
    static func from(password: Any) -> CommonPassword?{
        if let password = password as? WebsitePassword{
            return CommonPassword(name: password.name, description: password.description, password: password.password,type: password.type, originPassword: password)
        }
        
        if let password = password as? PaymentCardPassword{
            return CommonPassword(name: password.name, description: password.description, password: password.password,type: password.type, originPassword: password)
        }
        
        if let password = password as? BankPassword{
            return CommonPassword(name: password.name, description: password.description, password: password.password,type: password.type, originPassword: password)
        }
        
        return nil
    }
}
