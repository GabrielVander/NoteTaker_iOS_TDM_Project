//
//  NoteTakerApp.swift
//  NoteTaker
//
//  Created by Gabriel on 30/11/22.
//
//

import SwiftUI

@main
struct NoteTakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
