//
//  PaymentCardFormView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct PaymentCardFormView: View {
    let password: Binding<PaymentCardPassword>
    
    var body: some View {
        Group{
            Section(header: Text("Info")) {
                TextField("Card Number", text: password.cardNumber.projectedValue)
                TextField("Password", text: password.password.projectedValue)
                TextField("Security Code", text: password.securityCode.projectedValue)
            }
        }
    }
}
