//
//  LoadingText.swift
//  cryptoPass
//
//  Created by Qiwei Li on 6/9/22.
//

import SwiftUI

/**
 Show a view or a progress indicator
 */
struct LoadingView<Content: View>: View {
    @ViewBuilder let content: () -> Content?
    let isLoading: Bool
    
    init (isLoading: Bool,  @ViewBuilder _ content: @escaping () -> Content){
        self.content = content
        self.isLoading = isLoading
    }
    
    init (@ViewBuilder _ content: @escaping () -> Content){
        self.isLoading = false
        self.content = content
    }
    
    var body: some View {
        Group{
            if isLoading {
                ProgressView()
            } else {
                content()
            }
        }
    }
}

struct LoadingText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoadingView(isLoading: true){
                Text("Hello world")
            }
            LoadingView{
                Text("Hello world")
            }
        }
    }
}
