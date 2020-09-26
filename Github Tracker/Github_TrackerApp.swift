//
//  Github_TrackerApp.swift
//  Github Tracker
//
//  Created by Kyler Freas on 9/24/20.
//

import SwiftUI
import WidgetKit

@main
struct Github_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                    // Open Pull Request URL if launched from widget
                    UIApplication.shared.open(url)
                }
                .onAppear(perform: {
                    // Update widget on open
                    WidgetCenter.shared.reloadAllTimelines()
                })
        }
    }
}
