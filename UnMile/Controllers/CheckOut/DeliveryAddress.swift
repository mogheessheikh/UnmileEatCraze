//
//  DeliveryAddress.swift
//  UnMile
//
//  Created by iMac on 01/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

protocol addAddressDelegate {
    func didTappedAddressButton (cell: DeliveryAddress)
}
class DeliveryAddress: UITableViewCell {

    @IBOutlet var deliveryAddress: UITextField!
    var delegate: addAddressDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func AddDeliveryAddress(_ sender: Any) {
        delegate?.didTappedAddressButton(cell: self)
    }
    
}
