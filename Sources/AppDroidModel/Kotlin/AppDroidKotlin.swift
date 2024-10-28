import Foundation
import OSLog

fileprivate let logger: Logger = Logger(subsystem: "AppDroid", category: "AppDroidKotlin")

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
    logger.info("setDoublePreference: \(name) = \(value)")
    UserDefaults.standard.set(value, forKey: name)
}

// SKIP @BridgeToSwift
func loadModuleBundleResourceContents(name: String, extension ext: String) throws -> String? {
    guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
        return nil
    }
    // TODO: make this Data, which requires that it be a bridged type
    return try String(contentsOf: url, encoding: .utf8)
}

