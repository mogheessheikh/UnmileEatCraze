//
//  section3Cell.swift
//  UnMile
//
//  Created by user on 9/3/19.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit
protocol radio_checkDelegate {
    func didCheck_Radio_CheckButton(cell: section3Cell)
}
class section3Cell: UITableViewCell {

    @IBOutlet weak var radio_check_button: UIButton!
    @IBOutlet weak var optionPrice: UILabel!
    @IBOutlet weak var optionName: UILabel!
    var delegate : radio_checkDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func radio_check_buttonPressed(_ sender: Any) {
        delegate?.didCheck_Radio_CheckButton(cell: self)
    }
}
