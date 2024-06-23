//
//  JSONPlaceholderApp.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import SwiftUI

@main
struct JSONPlaceholderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PhotoListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
