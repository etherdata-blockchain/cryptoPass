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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
