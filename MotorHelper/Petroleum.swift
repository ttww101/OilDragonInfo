//
//  Petroleum.swift
//  MotorHelper
//
//  Created by 孟軒蕭 on 22/03/2017.
//  Copyright © 2017 MichaelXiao. All rights reserved.
//


struct Petroleum: Codable {
    let name: String
    let price: String
    
    init(oilName: String, oilPrice: String) {
        self.name = oilName
        self.price = oilPrice
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case price = "price"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(price, forKey: .price)
    }
    
}
