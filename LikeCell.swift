//
//  LikeCell.swift
//  LuckyDog
//
//  Created by Mason Ballowe on 4/8/16.
//  Copyright © 2016 D27 Studios. All rights reserved.
//

import UIKit

class LikeCell: UITableViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    

}
