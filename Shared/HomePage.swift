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
                    .toolbar{
                        #if os(iOS)
                        ToolbarItem(placement: .navigationBarLeading){
                            Button(action: { userAccountModel.resetAccount() }){
                                Image(systemSymbol: .externaldriveFill)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button(action: {}){
                                Image(systemSymbol: .plus)
                            }
                        }
                        #elseif os(macOS)
                        Button(action: { userAccountModel.resetAccount() }){
                            Image(systemSymbol: .externaldriveFill)
                        }
                        Button(action: {}){
                            Image(systemSymbol: .plus)
                        }
                        #endif
                    }
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
