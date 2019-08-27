//
//  SideMenuCell.swift
//  UnMile
//
//  Created by iMac  on 19/06/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var imgSideMenu: UIImageView!
    @IBOutlet weak var lblSideMenu: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
