import UIKit
import Cosmos
import AVOSCloud

extension AddShopViewController {
func viewDidLoadDontEat(_ sender: Double, title: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func doneButtonTappedShouldListen(_ element: Double, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func submitBtnShouldnotSing(_ listener: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(listener, forKey: "listener")
}
func cleanTextFieldDontWantRun(_ sender: Float, isOk: Bool) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func dismissKeyboardShouldDance(_ target: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
