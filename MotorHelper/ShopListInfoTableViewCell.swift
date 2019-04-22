//
//  ShopListInfoTableViewCell.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 06/04/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

import UIKit
import Cosmos

class ShopListInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var score: CosmosView!
    @IBOutlet weak var address: UILabel!


    static let identifier = "ShopListInfoTableViewCell"
    static let height: CGFloat = 110.0
}
