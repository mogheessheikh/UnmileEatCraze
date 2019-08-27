//
//  DynamicCell.swift
//  UnMile
//
//  Created by iMac on 23/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class DynamicCell: UITableViewCell {

    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblItems: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
