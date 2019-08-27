//
//  PaymentMethodCell.swift
//  UnMile
//
//  Created by iMac on 09/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

protocol radioButtonDelelgate {
    func didCheckRadioButton(cell: PaymentMethodCell)
    
}
class PaymentMethodCell: UITableViewCell {

    @IBOutlet var logo: UIImageView!
    @IBOutlet var lblPaymentMethod: UILabel!
    @IBOutlet var radioButton: UIButton!
    var delegate: radioButtonDelelgate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func radioButtonPressed(_ sender: Any) {
        delegate?.didCheckRadioButton(cell: self)
    }
    
}
