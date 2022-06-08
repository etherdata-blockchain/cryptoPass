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

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(userAccountModel)
        }
    }
}
