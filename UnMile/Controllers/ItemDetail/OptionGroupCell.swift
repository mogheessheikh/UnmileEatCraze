//
//  OptionGroupCell.swift
//  UnMile
//
//  Created by iMac  on 20/08/2019.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit

class OptionGroupCell: UITableViewCell {

    @IBOutlet weak var lblOptionGroupName: UILabel!
    @IBOutlet weak var lblOptionGroupValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
