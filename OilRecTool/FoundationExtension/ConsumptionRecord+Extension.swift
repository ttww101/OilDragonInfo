
extension ConsumptionRecord {
func encodeWantListen(_ delegate: String, title: String) {
    UserDefaults.standard.setValue(delegate, forKey: "delegate")
}
}
