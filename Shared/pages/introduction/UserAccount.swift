//
//  UserAccount.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import web3


struct UserAccount: View {
    @EnvironmentObject var userAccountModel: UserAccountModel
    
    let account: EthereumAccount
    var color = Color.indigo
    
    var body: some View {
        VStack{
            TitleView(color: .green, icon: .checkmarkCircle, title: "Wallet Address: \(account.address.value)", subtitle: "You are all set!")
            Spacer()
            FilledButton(color: color, title: "Done", isLoading: nil){
                userAccountModel.setUpAccount(account)
            }
        }
        .padding()
    }
}


struct UserAccountView_Previews: PreviewProvider {
    static var previews: some View {
        UserAccount(account: try! EthereumAccount(keyStorage: EthereumKeyLocalStorage(), keystorePassword: "124"))
            .environmentObject(UserAccountModel())
    }
}
