//
//  RepositoryTableViewCell.swift
//  GitSearcher
//
//  Created by Dinesh Danda on 4/2/20.
//  Copyright © 2020 Dinesh Danda. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
