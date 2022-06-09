//
//  WebsiteFormView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct WebsiteFormView: View {
    let password: Binding<WebsitePassword>
    
    var body: some View {
        Group{
            Section(header: Text("Info")) {
                TextField("Username", text: password.userName.projectedValue)
                TextField("Password", text: password.password.projectedValue)
            }
        }
    }
}

