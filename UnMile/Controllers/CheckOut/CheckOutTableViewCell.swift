//
//  CheckOutTableViewCell.swift
//  UnMile
//
//  Created by iMac on 26/03/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class CheckOutTableViewCell: UITableViewCell {

    @IBOutlet var lblUser: UILabel!
    @IBOutlet var icons: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
