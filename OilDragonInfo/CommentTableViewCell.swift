
import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userComment: UILabel!
    @IBOutlet weak var commentView: UIView!
    static let identifier = "CommentTableViewCell"
    static let height: CGFloat = 50.0
}
