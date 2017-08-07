//
//  FeedListItemTableViewCell.swift
//  SightOnMock
//
//  Created by inatani soichiro on 2017/08/05.
//  Copyright © 2017年 inai17ibar. All rights reserved.
//

import UIKit

class FeedListItemTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var user_name: UILabel!
    @IBOutlet weak var title_name: UILabel!
    @IBOutlet weak var tag_name: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
