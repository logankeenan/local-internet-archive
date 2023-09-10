//
//  ContentView.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import SwiftUI
import DittoSwift

func writeStringToTempFile(_ content: String) -> URL? {
    let tempDir = FileManager.default.temporaryDirectory
    let tempFileName = UUID().uuidString + ".html"
    let tempFileURL = tempDir.appendingPathComponent(tempFileName)
    
    do {
        try content.write(to: tempFileURL, atomically: true, encoding: .utf8)
        print("Successfully wrote to \(tempFileURL.path)")
        return tempFileURL
    } catch let error {
        print("Failed to write file with error: \(error)")
        return nil
    }
}


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
                    NavigationLink(destination: DetailView(ditto: ditto, archive: archive)) {
                        Text(archive.title)
                    }
                }
            }
            
            HStack {
                TextField("Enter URL", text: $urlInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Archive") {
                    var title_pointer: UnsafeMutablePointer<CChar>?
                    var markup_pointer: UnsafeMutablePointer<CChar>?
                    let cUrl = urlInput.cString(using: .utf8)
                    
                    archive_url(cUrl, &title_pointer, &markup_pointer)
                    
                    let title = String(cString: title_pointer!)
                    let markup = String(cString: markup_pointer!)

                    free(title_pointer)
                    free(markup_pointer)
                    

                    let collection = ditto.store["archives"]
                    let archive = Archive(title: title)
                    do {
                        try collection.upsert([
                            "_id": archive.id,
                            "title": archive.title,
                            "markup": nil
                        ])
                    } catch {
                        print(error.localizedDescription)
                    }
                
                    if let path_string = writeStringToTempFile(markup)?.path {
                        let attachment = collection.newAttachment(path: path_string)                    
                        collection.findByID(archive.id).update { mutableDoc in
                            mutableDoc?["markup"].set(attachment)
                        }
                    } else {
                        print("could not write file to tmp location")
                    }
                    
                    
                    urlInput = ""
                }
            }
            .padding()
        }
        .navigationTitle("Local Internet Archive")
    }
}
