//
//  Message.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/13/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Firebase

struct Message {
    let text, fromId, toId: String
    let timestamp: Timestamp
    let isMessageFromCurrentLoggedUser: Bool
    
    init(dictionary: [String : Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isMessageFromCurrentLoggedUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
