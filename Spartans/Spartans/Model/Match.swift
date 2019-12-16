//
//  Match.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/14/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Foundation

struct Match{
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
