//
//  Archive.swift
//  ios-local-internet-archive
//
//  Created by Logan Keenan on 9/9/23.
//

import DittoSwift

struct Archive {
    let _id: String
    let title: String

    init(document: DittoDocument) {
        _id = document["_id"].stringValue
        title = document["title"].stringValue
    }
    
    init(title: String) {
        self._id = UUID().uuidString
        self.title = title
    }
}

extension Archive: Identifiable {
    var id: String {
        return _id
    }
}
