//
//  OrderItemsSummery.swift
//  UnMile
//
//  Created by iMac  on 02/07/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class OrderItemsSummery: UITableViewCell {

    @IBOutlet weak var lblSummeryItemName: UILabel!
    @IBOutlet weak var lblSummeryItemQuantity: UILabel!
    @IBOutlet weak var lblSummeryItemPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
