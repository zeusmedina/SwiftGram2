//
//  ImageTableViewCell.swift
//  SwiftGram
//
//  Created by zeus medina on 3/4/16.
//  Copyright © 2016 Zeus. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var dataImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
