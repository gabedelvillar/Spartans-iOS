//
//  User.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/3/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit


struct User: ProduceCardViewModel{
    let name: String
    let age: Int
    let activitty: String
    let imageName: String
    
    func toCardViewModel() -> CardViewModel {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
                   
       attributedText.append(NSMutableAttributedString(string: "  \(age)", attributes: [.font:UIFont.systemFont(ofSize: 24, weight: .regular)]))
       
       attributedText.append(NSMutableAttributedString(string: "\n\(activitty)", attributes: [.font:UIFont.systemFont(ofSize: 20, weight: .regular)]))

        return CardViewModel(imageName: imageName, attributedString: attributedText, textAlignment: .left)
    }
    

}


