//
//  yc_DevoteApp.swift
//  yc_Devote
//
//  Created by yc on 2023/08/25.
//

import SwiftUI

@main
struct yc_DevoteApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
