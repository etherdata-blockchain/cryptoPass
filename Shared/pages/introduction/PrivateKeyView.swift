//
//  PrivateKeyView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import web3

struct PrivateKeyView: View {
    let color = Color.indigo
    
    
    @State private var privateKey = ""
    @State private var secret = ""
    @State private var isLoading = false
    @State private var error: String?
    @State private var hasError = false
    @State private var userAccount: EthereumAccount?
    @State private var selection: Int?
    
    var body: some View {
        VStack{
            if let userAccount = userAccount {
                NavigationLink(destination: UserAccount(account: userAccount), tag: 1, selection: $selection){
                    
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
                Section(header: Text("Keystore")){
                    SecureField("Keystore Password", text: $secret)
                }
                
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
        .alert(isPresented: $hasError){
            Alert(title: Text("Error"), message: Text(error!), dismissButton: .default(Text("ok")))
        }
        
    }
    
    private func verify(){
        if (secret.count == 0 || privateKey.count == 0){
            hasError = true
            self.error = "Private key and secret should not be empty"
            return
        }
        
        isLoading = true
        do{
            let keyStoreage = EthereumKeyLocalStorage()
            //TODO: Replace 123
            userAccount = try EthereumAccount.importAccount(keyStorage: keyStoreage, privateKey: privateKey, keystorePassword: "123")
            selection = 1
        } catch {
            hasError = true
            self.error = error.localizedDescription
        }
    
        isLoading = false
    }
}

struct PrivateKeyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateKeyView()
    }
}
