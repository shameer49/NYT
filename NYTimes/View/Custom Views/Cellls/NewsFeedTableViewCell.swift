//
//  NewsFeedTableViewCell.swift
//  NYTimes
//
//  Created by Fingent on 08/08/18.
//  Copyright © 2018 fingent. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var newsFeedThumbImageView: UIImageView!
    @IBOutlet weak var newsFeedHeaderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var newsFeedSecondaryDesciptionLbl: UILabel!
    
    @IBOutlet weak var newsFeedDescriptionLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
