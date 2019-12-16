//
//  MatchesCell.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/14/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import LBTATools

class MatchesCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1").withRenderingMode(.alwaysOriginal), contentMode: .scaleAspectFill)
    let usernameLabel  = UILabel(text: "Username", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var item: Match!{
        didSet{
            usernameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
            
        }
    }
    
    override func setupViews() {
        super.setupViews()
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        stack(stack(profileImageView, alignment: .center), usernameLabel)
    }
}
