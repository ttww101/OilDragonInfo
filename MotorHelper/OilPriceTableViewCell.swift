//
//  OilPriceTableViewCell.swift
//  MotorHelper
//
//  Created by Wu on 2019/4/18.
//  Copyright © 2019 na. All rights reserved.
//

import UIKit

class OilPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var insetView: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.contentView.constraints(self, constant: UIEdgeInsets(top: 10, left: 5, bottom: -10, right: -5))
        self.insetView.layer.borderWidth = 1
        self.insetView.layer.cornerRadius = 4
        self.insetView.layer.borderColor = UIColor(red: 254/255, green: 196/255, blue: 43/255, alpha: 1).cgColor
    }
}
