import UIKit
import AVOSCloud
import NVActivityIndicatorView

extension ConsumptionViewController {
func viewWillAppearDontLook(_ target: String, isPass: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
func viewDidLoadDontWantListen(_ element: Double, isPass: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func requestRecordDontPattern(_ sender: Int, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func numberOfSectionsDontWantRun(_ message: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func tableViewWantScream(_ message: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func tableViewShouldnotSing(_ para: Bool, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func tableViewCanPattern(_ element: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func tableViewDontSleep(_ sender: String, title: String) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
func tableViewCannotLook(_ view: Bool, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func addRecordShouldnotWalk(_ target: Bool, models: Double, title: String, isGood: Float) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
