//
//  PasswordRow.swift
//  cryptoPass (iOS)
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI



struct PasswordRow: View {
    let password: CommonPassword
    
    var body: some View {
        HStack {
            Image(systemSymbol: .lanyardcardFill)
                .foregroundColor(.indigo)
            VStack(alignment: .leading){
                HStack{
                    Text(password.type.rawValue)
                        .font(.caption)
                        .fontWeight(.bold)
                    Spacer()
                }
                HStack{
                    Text(password.name)
                    Spacer()
                }
            }
        }
    }
        
}

struct PasswordRow_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRow(password: CommonPassword(name: "hello", description: "world",password: "abcde" ,type: .bank, originPassword: WebsitePassword(name: "a", description: "b", userName: "c", password: "d")))
    }
}
