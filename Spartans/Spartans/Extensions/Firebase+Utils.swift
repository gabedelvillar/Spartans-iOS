//
//  Firebase+Utils.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/8/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}

