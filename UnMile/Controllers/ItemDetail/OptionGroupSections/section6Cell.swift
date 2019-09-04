//
//  section6Cell.swift
//  UnMile
//
//  Created by user on 9/3/19.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit
protocol itemDelegate {
    func didPressAddItem(cell: section6Cell)
}
class section6Cell: UITableViewCell {

    @IBOutlet weak var addItemButton: UIButton!
    var delegate: itemDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
    delegate?.didPressAddItem(cell: self)
    }
}
