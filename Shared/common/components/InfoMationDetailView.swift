//
//  InfoMationDetailView.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI
import SFSafeSymbols

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: SFSafeSymbols.SFSymbol
    var color: Color = Color.purple

    var body: some View {
        HStack(alignment: .center) {
            Image(systemSymbol: imageName)
                .font(.largeTitle)
                .foregroundColor(color)
                .padding()
                .accessibility(hidden: true)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .accessibility(addTraits: .isHeader)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.top)
    }
}

struct InfoMationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        InformationDetailView(title: "Hello world", subTitle: "Hello world", imageName: SFSymbol.plus, color: Color.green)
            .preferredColorScheme(.dark)
        
    }
}
