//
//  MoneyismApp.swift
//  Shared
//
//  Created by Teruya Hasegawa on 22/05/22.
//

import SwiftUI

@main
struct MoneyismApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
