//
//  Introduction.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct Introduction: View {
    let color = Color.indigo
    
    @State var selection: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                TitleView(color: color, icon: .dotsAndLineVerticalAndCursorarrowRectangle, subtitle: "CryptoPass")
                Spacer()
            }
            
            InformationDetailView(title: "Secure", subTitle: "Cryptopass uses blockchain technology to ensure that your passwords are kept in a secure environment.", imageName: .lock, color: color)
            
            InformationDetailView(title: "Simple", subTitle: "CryptoPass simpplifies the difficulty of using blockchain, allowing every user to enjoy blockchain technology without worring about specific implementation logic.", imageName: .checkmarkCircleFill, color: color)
            
            InformationDetailView(title: "Fast", subTitle: "CryptoPass uses the ETD blockchain, high transaction speed and many nodes make your every use without waiting", imageName: .speedometer, color: color)
            Spacer(minLength: 40)
            NavigationLink(destination: PrivateKeyView(), tag: 1, selection: $selection){
                FilledButton(color: color, title: "Continue", isLoading: nil){
                    selection = 1
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .interactiveDismissDisabled(true)
        
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
            .preferredColorScheme(.dark)
    }
}
