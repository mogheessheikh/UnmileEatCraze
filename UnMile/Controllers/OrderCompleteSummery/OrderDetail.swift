//
//  OrderDetail.swift
//  UnMile
//
//  Created by iMac  on 02/07/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class OrderDetail: UITableViewCell {

    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
