import UIKit
import SystemConfiguration
import NVActivityIndicatorView

extension PetroleumPriceViewController {
func viewDidLoadDontSing(_ para: Double, isOk: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func getOilInfoCanJump(_ sender: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func reloadDontJump(_ message: Float, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
}
