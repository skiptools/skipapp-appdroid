import Foundation
import Observation

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

    public func slideValues() { // (after: Double? = 0.0) {
//        if let after = after {
//            // FIXME: does not work on Android. Perhaps we need to manually start the DispatchQueue's run loop or something?
//            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(after * 1000.0))) {
//                self.slideValueSet()
//            }
//        } else {
            self.slideValueSet()
//        }
    }

    private func slideValueSet() {
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
