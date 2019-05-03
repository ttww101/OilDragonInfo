import UIKit

extension PetroleumPriceTableViewCell {
func awakeFromNibDontWantLoud(_ view: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
}
