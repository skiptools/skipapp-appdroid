import Foundation

// SKIP @BridgeToSwift
func getJavaSystemProperty(_ name: String) -> String? {
    #if SKIP
    return java.lang.System.getProperty(name)
    #else
    return nil
    #endif
}

// SKIP @BridgeToSwift
func getDoublePreference(_ name: String) -> Double {
    UserDefaults.standard.double(forKey: name)
}

// SKIP @BridgeToSwift
func setDoublePreference(_ name: String, value: Double) {
    UserDefaults.standard.set(value, forKey: name)
}
