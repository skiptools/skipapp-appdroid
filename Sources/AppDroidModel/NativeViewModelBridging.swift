import Foundation
import Observation
import SkipAndroidBridge

// doesn't work…
//extension ViewModel { typealias Observation = SkipBridge.Observation }


// DOES work
//typealias Observation = SkipBridge.Observation


public func callingEnvironment() -> String {
    #if SKIP
    return "Skip"
    #elseif os(Android)
    return "Android"
    #elseif os(iOS)
    return "iOS"
    #else
    return "other…"
    #endif
}

//public func getJavaSystemPropertyViaSwift(_ name: String) -> String? {
//    getJavaSystemProperty(name)
//}

public var bridgedString = "😀" + "🚀"

public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }

public class SwiftClass {
    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public init() {
    }

    public func getString() -> String {
        "SwiftClass"
    }
}
