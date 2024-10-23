import Foundation
import Observation
#if !SKIP
// TODO: the transpiler should insert this automatically
import struct SkipBridge.Observation
#endif

// SKIP @BridgeToKotlin
@Observable public class ViewModel {
    public var color = ColorModel()

    public init() {
    }

    public func randomizeAsync() async {
        randomize()
    }

    //public func randomize(delay: Double) async {
    public func randomize() {
        color.values.hue = Double.random(in: 0.0...1.0)
        color.values.saturation = Double.random(in: 0.0...1.0)
        color.values.brightness = Double.random(in: 0.0...1.0)
        color.values.opacity = Double.random(in: 0.0...1.0)
    }

    public func slideValues() {
        slideValue(&color.values.hue)
        slideValue(&color.values.saturation)
        slideValue(&color.values.brightness)
        slideValue(&color.values.opacity)
    }

    private func slideValue(_ value: inout Double) {
        if Int64((value * 1000.0).rounded(.toNearestOrEven)) % 2 == 0 {
            value += 0.002
            if value >= 1.0 {
                value = 0.999
            }
        } else {
            value -= 0.002
            if value <= 0.0 {
                value = 0.0
            }
        }
    }
}

// SKIP @BridgeToKotlin
@Observable public class ColorModel {
    public var values = HSLValues()

    public var hsl: Array<Double> {
        [values.hue, values.saturation, values.brightness, values.opacity]
    }

    public init() {
    }
}

// SKIP @BridgeToKotlin
@Observable public class HSLValues {
    public var hue = 0.5
    public var saturation = 0.5
    public var brightness = 0.5
    public var opacity = 1.0

    public init() {
    }
}


// SKIP @BridgeToKotlin
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

// SKIP @BridgeToKotlin
public func getJavaSystemPropertyViaSwift(_ name: String) -> String? {
    getJavaSystemProperty(name)
}

// SKIP @BridgeToKotlin
public var bridgedString = "😀" + "🚀"

// SKIP @BridgeToKotlin
public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }

// SKIP @BridgeToKotlin
public class SwiftClass {
    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public init() {
    }

    public func getString() -> String {
        "SwiftClass"
    }
}



// Without this we get the crash on launch: 08-09 18:45:51.978 10431 10431 E AndroidRuntime: java.lang.UnsatisfiedLinkError: dlopen failed: cannot locate symbol "_ZN5swift9threading5fatalEPKcz" referenced by "/data/app/~~aevIacTPjMLuc5Cymf5l-A==/skip.droid.app--cf8i3s7JV9Ln9saNnThMg==/base.apk!/lib/arm64-v8a/libswiftObservation.so"...
// Seem like Swift/lib/Threading/Errors.cpp (https://github.com/swiftlang/swift/blob/3934f78ecdd53031ac40d68499f9ee046a5abe50/lib/Threading/Errors.cpp#L13) is missing
@_cdecl("_ZN5swift9threading5fatalEPKcz")
func swiftThreadingFatal() { }
