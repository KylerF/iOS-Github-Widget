//
//  Github_CheckerApp.swift
//  Github Checker
//
//  Created by Kyler Freas on 9/24/20.
//

import SwiftUI

@main
struct Github_CheckerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
