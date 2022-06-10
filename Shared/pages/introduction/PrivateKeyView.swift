//
//  PrivateKeyView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import web3

struct PrivateKeyView: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    let color = Color.indigo
    
    
    @State private var privateKey = ""
    @State private var isLoading = false
    @State private var error: PrivateKeyError?
    @State private var hasError = false
    @State private var selection: Routes?
    
    var body: some View {
        VStack{
            if let userAccount = userAccountModel.userAccount {
                NavigationLink(destination: UserAccount(account: userAccount, privateKey: privateKey.data(using: .utf8)!), tag: Routes.finishSettingUpPrivateKey, selection: $selection){
                    
                }
            }
            Spacer()
            Text("Enter your pviate key here")
                .font(.title)
                .fontWeight(.bold)
            Text("We need this to interact with the ETD blockchain")
                .padding()
            
            Spacer()
            Form{
                Section(header: Text("Private key")){
                    TextEditor(text: $privateKey)
                        .frame(height: 200)
                }
            }
            
            FilledButton(color: color, title: "Verify", isLoading: nil) {
               verify()
            }
            Spacer()
        }
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .alert(isPresented: $hasError, error: error) {
            Button(action: { hasError = false}) {
                Text("Close")
            }
        }
        
    }
    
    private func verify(){
        if (privateKey.count == 0){
            hasError = true
            error = .emptyPrivateKey
            return
        }
        
        isLoading = true
        do{
            try userAccountModel.importAccount(privateKey: privateKey)
            selection = Routes.finishSettingUpPrivateKey
        } catch {
            hasError = true
            self.error = .invalidPrivateKey
        }
    
        isLoading = false
    }
}

struct PrivateKeyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateKeyView()
    }
}
