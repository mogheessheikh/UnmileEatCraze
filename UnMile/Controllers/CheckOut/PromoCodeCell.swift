//
//  PromoCodeCell.swift
//  UnMile
//
//  Created by iMac on 10/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

protocol PromoCodeDelegate {
    func didTappedVerificationButton() 
}

class PromoCodeCell: UITableViewCell {
    
    
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var promoTextField: UITextField!
    
    var delegate: PromoCodeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func verifyButtonTapped(_ sender: Any) {
        delegate?.didTappedVerificationButton()
    }
}
