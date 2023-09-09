//
//  ArchiveViewModel.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import Foundation
import DittoSwift

class ArchiveViewModel: ObservableObject {

    @Published var archives = [Archive]()

    let ditto: Ditto
    var liveQuery: DittoLiveQuery?
    var subscription: DittoSubscription?

    init(ditto: Ditto) {
        self.ditto = ditto
        self.subscription = ditto.store["archives"].findAll().subscribe()
        self.liveQuery = ditto.store["archives"]
            .findAll()
            .observeLocal(eventHandler: {  docs, _ in
                self.archives = docs.map({ Archive(document: $0) })
            })
    }
    
}
