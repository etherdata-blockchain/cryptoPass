//
//  PasswordForm.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct PasswordForm: View {
    @State private var selection = PasswordType.website
    @State private var basePassword: BasePassword = BasePassword(name: "", description: "", password: "", type: PasswordType.website)
    @State private var bankPassword: BankPassword = BankPassword(name: "", description: "", userName: "", password: "", securityQuestions: [], secondaryPassword: "")
    @State private var websitePassword: WebsitePassword = WebsitePassword(name: "", description: "", userName: "", password: "")
    @State private var paymentCardPassword: PaymentCardPassword = PaymentCardPassword(name: "", description: "", password: "", cardNumber: "", securityCode: "")
    
    var body: some View {
        Form{
            Section(header: Text("Form type")){
                Picker("Password Type", selection: $selection) {
                    ForEach(PasswordType.allCases, id: \.rawValue){
                        type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section(header: Text("Basic Info")) {
                TextField("Name", text: $basePassword.name)
                TextEditorWithPlaceholder(label: "Description", text: $basePassword.description)
                    .frame(height: 150)
                
            }
            renderFormViewByType()
        }
        .navigationTitle(Text("Create a new password"))
        .toolbar{
            Button(action: { submit() }) {
                Text("Submit")
            }
        }
    }
    
    private func submit(){
        switch (selection){
        case PasswordType.website:
            websitePassword.copyFrom(password: basePassword)
        case PasswordType.bank:
            bankPassword.copyFrom(password: basePassword)
        case PasswordType.paymentCard:
            paymentCardPassword.copyFrom(password: basePassword)
        }
    }
    
    private func renderFormViewByType() -> AnyView{
        switch (selection){
        case PasswordType.bank:
            return AnyView(BankFormView(password: $bankPassword))
        case PasswordType.website:
            return AnyView(WebsiteFormView(password: $websitePassword))
        case PasswordType.paymentCard:
            return AnyView(PaymentCardFormView(password: $paymentCardPassword))
        }
    }
}

struct PasswordForm_Previews: PreviewProvider {
    static var previews: some View {
        PasswordForm()
    }
}
