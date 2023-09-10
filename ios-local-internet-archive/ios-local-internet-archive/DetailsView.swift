//
//  DetailsView.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI
import WebKit
import DittoSwift

struct DetailView: View {
    let archive: Archive
    let ditto: Ditto
    
    @State private var fileURLString: String = ""
    
    init(ditto: Ditto, archive: Archive) {
        self.ditto = ditto
        self.archive = archive
    }

    var body: some View {
        VStack {
            if !fileURLString.isEmpty {
                WebView(urlString: fileURLString)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
        }
        .onAppear() {
            fetchData()
        }
    }
    
    func fetchData() {
        let doc = ditto.store["archives"].findByID(archive.id).exec()!
        let token = doc["markup"].attachmentToken!
        
        ditto.store["archives"].fetchAttachment(token: token) { event in
            switch event {
            case .completed(let attachment):
                do {
                    let tempDir = FileManager.default.temporaryDirectory
                    let tempFileName = UUID().uuidString + ".html"
                    let tempFileURL = tempDir.appendingPathComponent(tempFileName)
                    
                    try attachment.copy(toPath: tempFileURL.path)
                    
                    DispatchQueue.main.async {
                        fileURLString = tempFileURL.absoluteString
                    }
                } catch {
                    print("Error copying attachment to tmp directory: \(error)")
                }
                
            default:
                print("Error: event case \(event) not handled")
            }
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
