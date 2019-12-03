//
//  HomeBottomControlsStackView.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 11/30/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let subviews = [ #imageLiteral(resourceName: "refresh_circle"),  #imageLiteral(resourceName: "dismiss_circle"),  #imageLiteral(resourceName: "super_like_circle"),  #imageLiteral(resourceName: "like_circle"),  #imageLiteral(resourceName: "boost_circle")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            
            return button
        }
        
       
        
        
        subviews.forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
