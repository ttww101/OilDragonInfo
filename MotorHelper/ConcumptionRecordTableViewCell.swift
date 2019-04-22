
import UIKit

class ConcumptionRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var oilType: UILabel!
    @IBOutlet weak var numOfOil: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var dateOfAddRecord: UILabel!
    @IBOutlet weak var totalKM: UILabel!
    @IBOutlet weak var grayview: UIView!

    static let identifier = "ConcumptionRecordTableViewCell"
    static let height: CGFloat = 80.0
}
