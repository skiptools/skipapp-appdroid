import Foundation
import CoreFoundation
import Observation
import SkipBridge

#if !os(Android)
// TODO: Android-native logging module
import OSLog
fileprivate let logger: Logger = Logger(subsystem: "AppDroid", category: #fileID)
#endif

// SKIP @BridgeToKotlin
@Observable public class ViewModel {
    public var color = ColorModel()
    public var useMainActor: Bool = false

    public var autoSlide: Bool = false {
        didSet {
            if autoSlide {
                startAutosliding()
            }
        }
    }

    /// A persistent value that stores the speed of the auto-slide feature.
    public var slideSpeed: Double = getDoublePreference("slideSpeed") {
        didSet {
            // update the persistent store with the new value
            setDoublePreference("slideSpeed", value: slideSpeed)
        }
    }

    public init() {
    }

    public func randomizeAsync() async {
        #if !os(Android)
        logger.info("randomizeAsync invoked")
        #endif
        randomize()
    }

    //public func randomize(delay: Double) async {
    public func randomize() {
        color.values.hue.randomize(in: 0.0...1.0)
        color.values.saturation.randomize(in: 0.0...1.0)
        color.values.brightness.randomize(in: 0.0...1.0)
        color.values.opacity.randomize(in: 0.0...1.0)
    }

    private func startAutosliding() {
        Task {
            while self.autoSlide == true {
                if self.useMainActor == true {
                    await self.slideValuesMain()
                    self.dispatchMain()
                } else {
                    self.slideValues()
                }
                try await Task.sleep(for: Duration.milliseconds(self.slideSpeed * 1000.0))
            }
        }
    }

    private func dispatchMain() {
        // FIXME: MainActor call doesn't work on Android (probably related to DispatchQueue.main.async also not working)
        // https://forums.swift.org/t/prepitch-using-mainactor-and-dispatchqueue-main-async-without-foundation/61274/2
        #if os(Android)
        //CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true) // doesn't work
        //dispatchMainQueueCallback(nil) // doesn't work
        #endif
    }

    /// Bump the values on the main actor – not currently working on Android
    @MainActor private func slideValuesMain() {
        self.slideValueSet()
    }

    public func slideValues() { // (after: Double? = 0.0) {
        self.slideValueSet()

        // FIXME: does not work on Android. Perhaps we need to manually start the DispatchQueue's run loop or something?
        // if let after = after {
        //     DispatchQueue.main.asyncAfter(deadline: .now() + seconds(Int(after * 1000.0))) {
        //         self.slideValueSet()
        //     }
        // }
    }

    private func slideValueSet() {
        slideValue(&color.values.hue)
        slideValue(&color.values.saturation)
        slideValue(&color.values.brightness)
        slideValue(&color.values.opacity)
    }

    /// Bumps the value up or down between 0.0 and 1.0.
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

fileprivate protocol Randomizable where Self : Comparable {
    mutating func randomize(in: ClosedRange<Self>)
}

/// An example of Swift language features (retroactive protocol conformance and mutating self) that aren't available in Skip-transpiled code.
extension Double : Randomizable {
    mutating func randomize(in range: ClosedRange<Self>) {
        self = Self.random(in: range)
    }
}

// SKIP @BridgeToKotlin
@Observable public class ColorModel {
    public var values = HSLValues()

    init() {
    }

    public var hsl: Array<Double> {
        [values.hue, values.saturation, values.brightness, values.opacity]
    }

    /// Converts the HSBA values into an RGBA hex string
    public var asRGBHexString: String {
        // Ensure input values are in valid ranges
        let h = max(0, min(1, values.hue))
        let s = max(0, min(1, values.saturation))
        let b = max(0, min(1, values.brightness))
        let a = max(0, min(1, values.opacity))

        // Convert HSBA to RGBA
        let i = floor(h * 6)
        let f = h * 6 - i
        let p = b * (1 - s)
        let q = b * (1 - f * s)
        let t = b * (1 - (1 - f) * s)

        var r, g, bl: Double

        switch Int(i) % 6 {
        case 0: (r, g, bl) = (b, t, p)
        case 1: (r, g, bl) = (q, b, p)
        case 2: (r, g, bl) = (p, b, t)
        case 3: (r, g, bl) = (p, q, b)
        case 4: (r, g, bl) = (t, p, b)
        case 5: (r, g, bl) = (b, p, q)
        default: (r, g, bl) = (0, 0, 0)
        }

        // Convert to 8-bit values
        let red = Int(round(r * 255))
        let green = Int(round(g * 255))
        let blue = Int(round(bl * 255))
        let alpha = Int(round(a * 255))

        // Convert to hex string with alpha
        return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
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

#if os(Android)
// see: https://forums.swift.org/t/prepitch-using-mainactor-and-dispatchqueue-main-async-without-foundation/61274/2
@_silgen_name("_dispatch_main_queue_callback_4CF")
public func dispatchMainQueueCallback(_ msg: UnsafeMutableRawPointer?) -> Void
#endif
