
struct ConsumptionRecord: Codable {
    var date: String
    var oilType: String
    var oilPrice: String
    var numOfOil: String
    var totalPrice: String
    var totalKM: String

    init(date: String, oilType: String, oilPrice: String, numOfOil: String, totalPrice: String, totalKM: String) {
        self.date = date
        self.oilType = oilType
        self.oilPrice = oilPrice
        self.numOfOil = numOfOil
        self.totalPrice = totalPrice
        self.totalKM = totalKM
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "date"
        case oilType = "oilType"
        case oilPrice = "oilPrice"
        case numOfOil = "numOfOil"
        case totalPrice = "totalPrice"
        case totalKM = "totalKM"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(oilType, forKey: .oilType)
        try container.encode(oilPrice, forKey: .oilPrice)
        try container.encode(numOfOil, forKey: .numOfOil)
        try container.encode(totalPrice, forKey: .totalPrice)
        try container.encode(totalKM, forKey: .totalKM)
    }
    
}
