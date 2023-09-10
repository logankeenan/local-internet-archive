//
//  ios_local_internet_archiveApp.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI
import DittoSwift

@main
struct ios_local_internet_archiveApp: App {
    let persistenceController = PersistenceController.shared
    let ditto: Ditto
    
    @State var isPresentingAlert = false
    @State var errorMessage = ""
    
    init() {
            guard let infoDictionary = Bundle.main.infoDictionary,
                  let appId = infoDictionary["APP_ID"] as? String,
                  let token = infoDictionary["TOKEN"] as? String else {
                fatalError("APP_ID or TOKEN not set in Info.plist")
            }
            
            self.ditto = Ditto(identity: .onlinePlayground(
                appID: appId,
                token: token)
            )
        }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(ditto: ditto)
                    .onAppear(perform: {
                        do {
                            try ditto.startSync()                            
                        } catch (let err){
                            isPresentingAlert = true
                            errorMessage = err.localizedDescription
                        }
                    })
                    .alert(isPresented: $isPresentingAlert) {
                        Alert(
                            title: Text("Uh Oh"),
                            message: Text("There was an error trying to start the sync. Here's the error \(errorMessage) Ditto will continue working as a local database."), dismissButton: .default(Text("Got it!")))
                        
                    }
            }
        }
    }
}
