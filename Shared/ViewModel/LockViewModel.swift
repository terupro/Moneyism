//
//  LockViewModel.swift
//  Moneyism (iOS)
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI
import LocalAuthentication

// MARK: Face Lock Properties
class LockViewModel: ObservableObject{
    @Published var isUnlocked: Bool = false
    @Published var isAvailable: Bool = true
    
    // MARK: Authenticating With User
    func authenticateUser(){
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "プライバシーを保護するためのセキュリティ") { status, _ in
                DispatchQueue.main.async {
                    self.isUnlocked = status
                }
            }
        }else{
            isAvailable = false
            isUnlocked = false
        }
    }
}
