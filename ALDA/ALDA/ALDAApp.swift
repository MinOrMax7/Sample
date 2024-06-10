//
//  ALDAApp.swift
//  ALDA
//
//  Created by Mingxin Xie on 5/25/24.
//

import SwiftUI

@main
struct ALDAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
