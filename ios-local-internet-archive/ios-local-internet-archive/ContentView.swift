//
//  ContentView.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI

struct ContentView: View {
    @State private var urlInput: String = ""
    let websites = [
        ("Google", "https://www.google.com"),
        ("Reddit", "https://www.reddit.com")
    ] // Hardcoded for now

    var body: some View {
        VStack {
            List(websites, id: \.0) { website in
                NavigationLink(destination: DetailView(website: website)) {
                    Text(website.0)
                }
            }

            HStack {
                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Archive") {
                    // Your custom code for archiving
                }
            }
            .padding()
        }
        .navigationTitle("Website List")
    }
}
