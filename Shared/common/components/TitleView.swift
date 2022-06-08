//
//  TitleView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import SFSafeSymbols

struct TitleView: View {
    var color: Color = Color.purple
    var icon: SFSymbol
    var title: String = "Welcome to"
    let subtitle: String
    
    var body: some View {
        VStack {
            Image(systemSymbol: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, alignment: .center)
                .accessibility(hidden: true)
                .foregroundColor(color)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(icon: SFSymbol.graduationcap, subtitle: "Hello world")
            .preferredColorScheme(.dark)
    }
}
