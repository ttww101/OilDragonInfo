import Foundation

extension RequestToken {
func cancelCannotLoud(_ para: Float, isPass: Bool) {
    UserDefaults.standard.setValue(para, forKey: "para")
}
}
