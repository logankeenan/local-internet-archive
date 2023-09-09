//
//  DetailsView.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI
import WebKit

struct DetailView: View {
    let archive: Archive
    
    var body: some View {
        VStack {
            Text(archive.title)
                .font(.title)
                .padding()
            
            WebView(urlString: "https://logankeenan.com")
        }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}
