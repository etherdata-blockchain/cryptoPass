//
//  PasswordFormModel.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/10/22.
//

import Foundation

class PasswordFormModel: ObservableObject{
    @Published  var selection = PasswordType.website
    @Published  var basePassword: BasePassword = BasePassword(name: "", description: "", password: "", type: PasswordType.website)
    @Published  var bankPassword: BankPassword = BankPassword(name: "", description: "", userName: "", password: "", securityQuestions: [], secondaryPassword: "")
    @Published  var websitePassword: WebsitePassword = WebsitePassword(name: "", description: "", userName: "", password: "")
    @Published  var paymentCardPassword: PaymentCardPassword = PaymentCardPassword(name: "", description: "", password: "", cardNumber: "", securityCode: "")
    
    func initialize(with password: CommonPassword){
        if let originPassword = password.originPassword as? BankPassword{
            bankPassword = originPassword
            selection = .bank
        }
        
        if let originPassword = password.originPassword as? PaymentCardPassword{
            paymentCardPassword = originPassword
            selection = .paymentCard
        }
        
        if let originPassword = password.originPassword as? WebsitePassword{
            websitePassword = originPassword
            selection = .website
        }
        basePassword = password.toBasePassword()
    }
    
    func prepareSubmissionData() -> Data?{
        var submitData: Data?
        switch (selection){
        case PasswordType.website:
            websitePassword.copyFrom(password: basePassword)
            submitData = try? JSONEncoder().encode(websitePassword)
        case PasswordType.bank:
            bankPassword.copyFrom(password: basePassword)
            submitData = try? JSONEncoder().encode(bankPassword)
        case PasswordType.paymentCard:
            paymentCardPassword.copyFrom(password: basePassword)
            submitData = try? JSONEncoder().encode(paymentCardPassword)
        }
        return submitData
    }
    
    func clear(){
        selection = PasswordType.website
        basePassword = BasePassword(name: "", description: "", password: "", type: PasswordType.website)
        bankPassword = BankPassword(name: "", description: "", userName: "", password: "", securityQuestions: [], secondaryPassword: "")
        websitePassword = WebsitePassword(name: "", description: "", userName: "", password: "")
        paymentCardPassword = PaymentCardPassword(name: "", description: "", password: "", cardNumber: "", securityCode: "")
    }
    
}
