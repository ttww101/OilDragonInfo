import Foundation

extension DataLoader {
func getDataDontWantRun(_ sender: Double, isPass: Bool) {
    UserDefaults.standard.setValue(sender, forKey: "sender")
}
}
