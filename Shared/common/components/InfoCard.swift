//
//  InfoCard.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import SFSafeSymbols

struct InfoCard: View {
    let title: String
    let subtitle: String
    let color: Color
    let unit: String
    let icon: SFSymbol
    
    var body: some View {
        VStack{
            HStack{
                Image(systemSymbol: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(color)
                    .fontWeight(.bold)
                Spacer()
            }
            Spacer(minLength: 10)
            HStack(alignment: .bottom){
                Text(subtitle)
                    .font(.title)
                    .fontWeight(.bold)
                Text(unit)
                Spacer()
            }
        }
        .padding(3.0)
        .cornerRadius(10)
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(title: "Hello world", subtitle: "1234", color: Color.green, unit: "steps", icon: .checkmark)
            .previewLayout(.sizeThatFits)
            .frame(width: 200, height: 200)
    }
}
