//
//  Messages.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/12/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "kelly1"))
    
    let usernameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16), textAlignment: .center, numberOfLines: 2)
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.4243166447, green: 0.8746193647, blue: 1, alpha: 1))
    
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        usernameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        
        
        let middleStack = hstack(
            stack(userProfileImageView, usernameLabel, spacing: 8,  alignment: .center),
            alignment: .center
        
        )
        
        hstack(backButton, middleStack).withMargins(.init(top: 0, left: 4, bottom: 0, right: 16))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
