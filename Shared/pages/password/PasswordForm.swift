//
//  PasswordForm.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import web3

struct PasswordForm: View {
    @EnvironmentObject var cryptoPassModel: CryptoPassModel
    @EnvironmentObject var transactionModel: TransactionModel
    @EnvironmentObject var passwordFormModel: PasswordFormModel
    
    var editMode = true
    private let password: CommonPassword?
    
    init(editMode: Bool=true){
        self.editMode = editMode
        self.password = nil
    }
    
    /**
     Initialize with stored password
     */
    init(editMode: Bool=true, password: CommonPassword){
        self.editMode = editMode
        self.password = password
    }
    
    
    var body: some View {
        Form{
            Section(header: Text("Form type")){
                Picker("Password Type", selection: $passwordFormModel.selection) {
                    ForEach(PasswordType.allCases, id: \.rawValue){
                        type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section(header: Text("Basic Info")) {
                TextField("Name", text: $passwordFormModel.basePassword.name)
                TextEditorWithPlaceholder(label: "Description", text: $passwordFormModel.basePassword.description)
                    .frame(height: 150)
                
            }
            renderFormViewByType()
        }
        .onAppear{
            if let password = password {
                passwordFormModel.initialize(with: password)
            }
        }
        .onDisappear{
            passwordFormModel.clear()
        }
        .disabled(!editMode)
        .sheet(isPresented: $transactionModel.showConfirmationDialog){
            ConfirmationPage()
        }
        .navigationTitle(Text(editMode ? "Create a new password" : "Password"))
        .toolbar{
            if editMode {
                Button(action: { submit() }) {
                    Text("Submit")
                }
            }
        }
    }
    

    private func submit(){
        let submitData = passwordFormModel.prepareSubmissionData()
        if let submitData = submitData {
            do{
                if let transaction = try cryptoPassModel.client?.prepareAddSecret(secret: submitData) {
                    transactionModel.showConfirmation(transaction: transaction)
                }

            } catch{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func renderFormViewByType() -> AnyView{
        switch (passwordFormModel.selection){
        case PasswordType.bank:
            return AnyView(BankFormView(password: $passwordFormModel.bankPassword))
        case PasswordType.website:
            return AnyView(WebsiteFormView(password: $passwordFormModel.websitePassword))
        case PasswordType.paymentCard:
            return AnyView(PaymentCardFormView(password: $passwordFormModel.paymentCardPassword))
        }
    }
}

struct PasswordForm_Previews: PreviewProvider {
    static var previews: some View {
        PasswordForm()
    }
}
