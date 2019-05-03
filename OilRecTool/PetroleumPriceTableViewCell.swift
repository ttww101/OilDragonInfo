//
//  PetroleumPriceTableViewCell.swift
//  OilRecTool
//
//  Created by candy on 2019/04/22.
//  Copyright © 2019 na. All rights reserved.
//

import UIKit

class PetroleumPriceTableViewCell: UITableViewCell {

    @IBOutlet weak var insetView: UIView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.insetView.layer.borderWidth = 1
        self.insetView.layer.cornerRadius = 4
        self.insetView.layer.borderColor = UIColor(red: 254/255, green: 196/255, blue: 43/255, alpha: 1).cgColor
    }
}
