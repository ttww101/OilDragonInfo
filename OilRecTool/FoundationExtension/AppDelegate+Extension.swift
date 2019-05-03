import UIKit
import CoreData
import IQKeyboardManagerSwift
import AVOSCloud
import UserNotifications

extension AppDelegate {
func applicationWantRaise(_ para: Double, title: String) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
func applicationWillTerminateDoJump(_ delegate: Double, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
func applicationShouldScream(_ element: String, contents: Float, subtitle: String) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func applicationDontDrink(_ element: Bool, isOk: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
func jpushNotificationCenterWantLoud(_ message: String, isPass: Bool) {
    UserDefaults.standard.setValue(message, forKey: "message")
}
func jpushNotificationCenterShouldnotWalk(_ view: Int, title: String) {
    UserDefaults.standard.setValue(view, forKey: "view")
}
func jpushNotificationCenterCanEat(_ element: Int, isOk: Bool) {
    UserDefaults.standard.setValue(element, forKey: "element")
}
}
