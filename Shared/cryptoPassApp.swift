//
//  cryptoPassApp.swift
//  Shared
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

@main
struct cryptoPassApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject var userAccountModel = UserAccountModel()
    @StateObject var cryptoPassModel = CryptoPassModel()
    @StateObject var transactionModel = TransactionModel()
    @StateObject var authenticationModel = AuthenticationModel()
    @StateObject var ethereumModel = EthereumModel()
    @StateObject var passwordFormModel = PasswordFormModel()

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userAccountModel)
                .environmentObject(cryptoPassModel)
                .environmentObject(transactionModel)
                .environmentObject(authenticationModel)
                .environmentObject(ethereumModel)
                .environmentObject(passwordFormModel)
        }
    }
}
