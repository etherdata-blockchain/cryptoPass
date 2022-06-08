//
//  FilledButton.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct FilledButton: View {
    let color: Color
    let title: String
    let isLoading: Bool?
    let onClick: () -> ()
    
    var body: some View {
        HStack{
            Spacer()
            Button(action: { onClick() }){
                Text(title)
                if isLoading == true {
                    ProgressView()
                        .padding(.leading, 3.0)
                    
                }
            }
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(color))
            .padding(.bottom)
            Spacer()
        }
    }
}


struct FilledButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilledButton(color: .purple, title: "Hello world", isLoading: nil) {
                
            }
            FilledButton(color: .purple, title: "Hello world", isLoading: true) {
                
            }
        }
    }
}
