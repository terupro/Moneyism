//
//  ContentView.swift
//  Shared
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Face/Touch ID Properties
    @StateObject var lockModel: LockViewModel = .init()
    @AppStorage("lock_content") var lockContent: Bool = false
    @Environment(\.scenePhase) var phase
    var body: some View {
        NavigationView{
            Home()
                .environmentObject(lockModel)
                .navigationBarHidden(true)
        }
        .overlay {
            ZStack{
                if !lockModel.isUnlocked && lockModel.isAvailable && lockContent{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            lockModel.authenticateUser()
                        }
                }
            }
        }
        .preferredColorScheme(.light)
        .onChange(of: phase) { newValue in
            if lockModel.isAvailable && lockContent{
                if newValue == .background || newValue == .inactive{
                    lockModel.isUnlocked = false
                }
                if newValue == .active && !lockModel.isUnlocked{
                    lockModel.authenticateUser()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
