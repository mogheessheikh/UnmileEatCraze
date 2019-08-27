//
//  RestaurantsCell.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/21/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class RestaurantsCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var isOpen: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cuisineTypes: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var serviceImage1: UIImageView!
    @IBOutlet weak var serviceImage2: UIImageView!
    @IBOutlet weak var serviceImage3: UIImageView!
    @IBOutlet weak var discountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = .none

        serviceImage1.tintColor = UIColor.initWithHex(hex: "FFA10E")
        serviceImage2.tintColor = UIColor.initWithHex(hex: "FFA10E")

        restaurantImage.layer.cornerRadius = 5
        restaurantImage.layer.masksToBounds = true

        isOpen.layer.cornerRadius = 5
        isOpen.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
