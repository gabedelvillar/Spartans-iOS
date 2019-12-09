//
//  AcivityPickerCell.swift
//  Spartans
//
//  Created by Gabriel Del VIllar De Santiago on 12/8/19.
//  Copyright © 2019 Gabriel Del VIllar De Santiago. All rights reserved.
//

import UIKit

class ActivityPickerCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
