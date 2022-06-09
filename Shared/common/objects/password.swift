//
//  password.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import Foundation

enum PasswordType: String, CaseIterable, Codable{
    case bank = "Bank"
    case website = "Website"
    case paymentCard = "PaymentCard"
    
}

struct SecurityQuestion: Codable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var answer: String
}

protocol Password : Identifiable, Codable{
    var name: String {get set}
    var description: String{get set}
    
    var password: String {get set}
    var type: PasswordType {get}
    
    mutating func copyFrom(password: BasePassword)
}


struct BasePassword: Password{
    mutating func copyFrom(password: BasePassword) {
        self.name = password.name
        self.description = password.description
    }
    
    var name: String
    
    var description: String
    
    var password: String
    
    var type: PasswordType
    
    var id: String = UUID().uuidString
}

struct WebsitePassword: Password{
    mutating func copyFrom(password: BasePassword) {
        self.name = password.name
        self.description = password.description
    }
    var name: String
    
    var description: String
    
    var userName: String
    
    var password: String
    
    var type: PasswordType = PasswordType.website
    
    var id: String = UUID().uuidString
}

struct BankPassword: Password{
    var name: String
    
    var description: String
    
    var userName: String
    
    var password: String
    
    var type: PasswordType = PasswordType.bank
    
    var id = UUID()
    var securityQuestions: [SecurityQuestion]
    var secondaryPassword: String;
    
    mutating func copyFrom(password: BasePassword) {
        self.name = password.name
        self.description = password.description
    }
}


struct PaymentCardPassword: Password{
    var name: String
    
    var description: String
    
    var password: String
    
    var type: PasswordType = PasswordType.paymentCard
    
    var id: String = UUID().uuidString
    
    var cardNumber: String
    
    var securityCode: String
    
    mutating func copyFrom(password: BasePassword) {
        self.name = password.name
        self.description = password.description
    }
}
