//
//  section4Cell.swift
//  UnMile
//
//  Created by user on 9/3/19.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit

class section4Cell: UITableViewCell {

    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var subview1: UIView!
    @IBOutlet weak var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func minusPressed(_ sender: Any) {
    }
    @IBAction func plusPressed(_ sender: Any) {
    }
}
