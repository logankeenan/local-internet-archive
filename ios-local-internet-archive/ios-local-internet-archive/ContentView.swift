//
//  ContentView.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI
import DittoSwift

struct ContentView: View {
    @State private var urlInput: String = ""
    @ObservedObject var viewModel: ArchiveViewModel
    
    
    let ditto: Ditto
    var liveQuery: DittoLiveQuery?
    var subscription: DittoSubscription?
    
    
    init(ditto: Ditto) {
        self.ditto = ditto
        self.viewModel = ArchiveViewModel(ditto: ditto)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.archives) { archive in
                    NavigationLink(destination: DetailView(archive: archive)) {
                        Text(archive.title)
                    }
                }
            }
            
            HStack {
                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Archive") {
                    
                    let archive = Archive(title: urlInput)
                    do {
                        try ditto.store["archives"].upsert([
                            "id": archive.id,
                            "title": archive.title,
                        ])
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    urlInput = ""
                }
            }
            .padding()
        }
        .navigationTitle("Archives")
    }
}
