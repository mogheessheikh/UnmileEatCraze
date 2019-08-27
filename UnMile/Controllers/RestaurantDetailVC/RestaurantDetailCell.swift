//
//  RestaurantDetailCell.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/31/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

protocol addItemDelegate {
    func didTappedAddButton(cell: RestaurantDetailCell)
    
}
class RestaurantDetailCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var addItem: UIButton!
    
    var delegate: addItemDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        restaurantImage.layer.cornerRadius = 5
        restaurantImage.layer.masksToBounds = true

        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true

        selectionStyle = .none

    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addItemTapped(_ sender: Any) {
        delegate?.didTappedAddButton(cell: self)
    }
    
}
