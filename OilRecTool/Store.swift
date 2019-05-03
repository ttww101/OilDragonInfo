//
//  Shop.swift
//  MotorHelper
//
//  Created by candy on 2019/04/22.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//

class Shop {
    let name: String
    let address: String
    let phone: String
    let objectID: String
    var rate: String?
    var comments: [String]?

    init(name: String, address: String, phone: String, objectID: String, rate: String? = nil, comments: [String]? = nil) {
        self.objectID = objectID
        self.name = name
        self.address = address
        self.phone = phone
        self.rate = rate
        self.comments = comments
    }
}

