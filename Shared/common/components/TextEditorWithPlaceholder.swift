//
//  TextEditorWithPlaceholder.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/8/22.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
    let label: String
    let text: Binding<String>
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                VStack{
                    Text("Description")
                        .foregroundColor(.gray)
                        .opacity(0.7)
                        .padding(.top, 10.0)
                        .padding(.leading, 3)
                    Spacer()
                }
            }
            
            TextEditor(text: text.projectedValue)
        }
    }
}

struct TextEditorWithPlaceholder_Previews: PreviewProvider {
    @State static var text: String = ""
    
    
    static var previews: some View {
        TextEditorWithPlaceholder(label: "Description", text: $text)
            .frame(height: 300)
    }
}
