//
//  OrderType.swift
//  UnMile
//
//  Created by iMac on 01/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

protocol orderTypeDelegate {
    func didToggleRadioButton(_ indexPath: IndexPath)
}

class OrderType: UITableViewCell {

   
    @IBOutlet var radioButton: UIButton!
    @IBOutlet var orderTypelbl: UILabel!
    var delegate: orderTypeDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCellItem() {
        
        let deselectedImage = UIImage(named: "radio-button-uncheck")?.withRenderingMode(.alwaysTemplate)
        let selectedImage = UIImage(named: "radio-button-check")?.withRenderingMode(.alwaysTemplate)
        radioButton.setImage(deselectedImage, for: .normal)
        radioButton.setImage(selectedImage, for: .selected)
        radioButton.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped(_ radioButton: UIButton) {
        print("radio button tapped")
        let isSelected = !self.radioButton.isSelected
        self.radioButton.isSelected = isSelected
        if isSelected {
            deselectOtherButton()
        }
        let tableView = self.superview as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        delegate?.didToggleRadioButton(tappedCellIndexPath)
    }

    func deselectOtherButton() {
        let tableView = self.superview?.superview as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        let indexPaths = tableView.indexPathsForVisibleRows
        for indexPath in indexPaths! {
            if indexPath.row != tappedCellIndexPath.row && indexPath.section == tappedCellIndexPath.section {
                let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! OrderType
                cell.radioButton.isSelected = false
            }
        }
    }

}
