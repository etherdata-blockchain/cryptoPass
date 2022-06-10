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
    @EnvironmentObject var cryptoPassModel: CryptoPassModel
    @EnvironmentObject var ethereumModel: EthereumModel
 
    @Environment(\.managedObjectContext) private var viewContext

    
    var body: some View {
        NavigationView {
            if let _ = userAccountModel.userAccount{
                LoginRequiredView {
                    Text("Login required")
                } child: {
                    PasswordList()
                }

            }
            TitleView(icon: .dotsAndLineVerticalAndCursorarrowRectangle, subtitle: "CryptoPass")
        }
        .onAppear{
            userAccountModel.initialize()
        }
        .onReceive(userAccountModel.$userAccount, perform: { account in
            if let account = account{
                cryptoPassModel.setUp(client: ethereumModel.ethereumClient, account: account, privateKey: userAccountModel.privateKey!)
            }
        })
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
