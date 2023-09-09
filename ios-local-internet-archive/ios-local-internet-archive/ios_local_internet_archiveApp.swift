//
//  ios_local_internet_archiveApp.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI

@main
struct ios_local_internet_archiveApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
            WindowGroup {
                NavigationView {
                    ContentView()
                }
            }
        }
}
