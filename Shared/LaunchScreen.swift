//
//  LaunchScreen.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 2022/11/04.
//

import SwiftUI

struct LaunchScreen: View {
    @State private var isLoading = true
    
    var body: some View {
        if isLoading {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color("Gradient1"),
                    Color("Gradient2"),]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
                Image("logo")
                    .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        } else {
            ContentView()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
