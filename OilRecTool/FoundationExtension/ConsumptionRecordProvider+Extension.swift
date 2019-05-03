import Foundation

extension ConsumptionRecordProvider {
func getConsumptionRecordDontLook(_ target: Double, isOk: Bool) {
    UserDefaults.standard.setValue(target, forKey: "target")
}
}
