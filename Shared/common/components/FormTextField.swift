//
//  FormTextField.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI

struct FormTextField<Leading: View, Trailing: View>: View {
    let leading: Leading
    let trailing: Trailing
    
    init(@ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing){
        self.leading = leading()
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack{
            leading
            Spacer()
            trailing
                .foregroundColor(.gray)
        }
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormTextField(leading: { Text("Hello world") }) {
            Text("Hello world")
        }
    }
}
