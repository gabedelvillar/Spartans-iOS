//
//  User.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/3/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit


struct User: ProduceCardViewModel{
    var name: String?
    var age: Int?
    var activity: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        // initialize user here
        self.age = dictionary["age"] as? Int
        self.activity = dictionary["activity"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : ""
                   
       attributedText.append(NSMutableAttributedString(string: "  \(ageString)", attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .regular)]))
       
        let activityString = activity != nil ? activity! : ""
        
       attributedText.append(NSMutableAttributedString(string: "\n\(activityString)", attributes: [.font:UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageUrls = [String]() // empty string array
        if let url = imageUrl1 {imageUrls.append(url)}
        if let url = imageUrl2 {imageUrls.append(url)}
        if let url = imageUrl3 {imageUrls.append(url)}

        return CardViewModel(uid: self.uid ?? "", imageNames: imageUrls, attributedString: attributedText, textAlignment: .left)
    }
    

}


