//
//  LoginRequiredView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/10/22.
//

import SwiftUI

struct LoginRequiredView<Content: View, Login: View>: View {
    @EnvironmentObject var authenticationModel: AuthenticationModel
    
    @ViewBuilder let loginScreen: () -> Login
    @ViewBuilder let child: () -> Content

    
    @State var hasLogined = false
    @State var error: AuthenticationError?
    @State var hasError = false
    
    var body: some View {
        Group{
            if hasLogined{
                child()
            } else {
                loginScreen()
            }
        }
        .alert(isPresented: $hasError, error: error, actions: {
            Button {
             hasError = false
            } label: {
                Text("ok")
            }

        })
        .onAppear{
            authenticationModel.authenticate { isAuthenticated, hasError in
                if isAuthenticated{
                    hasLogined = true
                } else {
                    self.hasError = true
                    self.error = .invalidIdentity
                }
                
                if hasError{
                    self.hasError = true
                    self.error = .invalidDevice
                }
            }
        }
    }
}

struct LoginRequiredView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRequiredView(loginScreen: { Text("You need to login first") }) {
            Text("Hello world")
        }
    }
}
