
import UIKit
import Cosmos

class ShopListInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var cosmosRatingView: CosmosView!
    @IBOutlet weak var address: UILabel!


    static let identifier = "ShopListInfoTableViewCell"
    static let height: CGFloat = 110.0
}
