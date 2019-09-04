//
//  section2Cell.swift
//  UnMile
//
//  Created by user on 9/3/19.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit

class section2Cell: UITableViewCell {

    @IBOutlet weak var subview1: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var subview2: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
