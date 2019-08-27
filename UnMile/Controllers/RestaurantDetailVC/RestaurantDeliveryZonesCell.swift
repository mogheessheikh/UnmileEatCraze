//
//  RestaurantDeliveryZonesCell.swift
//  UnMile
//
//  Created by Adnan Asghar on 2/6/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit



class RestaurantDeliveryZonesCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var minimumDelivery: UILabel!
    
    var delegate: PromoCodeDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
