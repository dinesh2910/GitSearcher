//
//  GitListTableViewCell.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/1/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit

class GitListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userRepoCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = userImage.frame.size.height/2.0
        userImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
