//
//  ContentView.swift
//  Shared
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import CoreData

struct HomePage: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        NavigationView {
            if let _ = userAccountModel.userAccount{
                PasswordList()
            }
            Text("CryptoPass")
        }

        .sheet(isPresented: $userAccountModel.shouldInitAccount){
           IntroductionPage()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomePage().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(UserAccountModel())
    }
}
