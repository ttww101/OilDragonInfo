
import UIKit

class ConsumptionTextTableViewCell: UITableViewCell {

    @IBOutlet weak var contentTextName: UILabel!
    @IBOutlet weak var contentTextField: UITextField!

    static let identifier = "ConsumptionTextTableViewCell"

    var index: TextFieldType?

}

enum TextFieldType {
    case oilPrice
    case numOfOil
    case totalPrice
    case totalKM
    case date
}
