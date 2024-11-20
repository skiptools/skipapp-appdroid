import Foundation
import Observation
import SkipFuse

fileprivate let logger: Logger = Logger(subsystem: "AppDroid", category: "NativeViewModel")

#if os(Android)
let defaults = UserDefaults.bridged
#else
let defaults = UserDefaults.standard
#endif

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

    public func fileURL() -> URL {
        URL.applicationSupportDirectory
    }

    /// A persistent value that stores the speed of the auto-slide feature.
    public var slideSpeed: Double = defaults.double(forKey: "slideSpeed") {
        didSet {
            // update the persistent store with the new value
            defaults.set(slideSpeed, forKey: "slideSpeed")
        }
    }

    public init() {
    }

    public func randomizeAsync() async {
        logger.info("randomizeAsync invoke")
        if self.useMainActor {
            DispatchQueue.main.async {
                self.randomize()
            }
        } else {
            randomize()
        }
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
                try await Task.sleep(for: Duration.milliseconds((1.0 - self.slideSpeed) * 10.0))
            }
        }
    }

    private func dispatchMain() {
        // FIXME: MainActor call doesn't work on Android (probably related to DispatchQueue.main.async also not working)
        // https://forums.swift.org/t/prepitch-using-mainactor-and-dispatchqueue-main-async-without-foundation/61274/2
#if os(Android)
        //CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, true) // doesn't work
        //dispatchMainQueueCallback(nil) // doesn't work
        //RunLoop.main.run(until: Date.distantFuture)
        //RunLoop.main.run()
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

    public func parseSampleResources() throws -> String {
        // Unused because we don't yet have any way of getting resources from the Android Swift side
        #if os(Android)
        // PackageResources is not implemented in Xcode's resource handling
        // https://github.com/swiftlang/swift-package-manager/issues/6969
        //let resourceData = Data(PackageResources.sample_resource_json)
        #endif
        //let resourceData = try! Data(contentsOf: Bundle.module.url(forResource: "sample_resource", withExtension: "json")!)

        // call up to Kotlin to use SkipFoundation.Bundle.module to get the resource contents
//        guard let resourceData = try loadModuleBundleResourceContents(name: "sample_resource", ext: "json")?.data(using: .utf8) else {
//            throw NativeError(errorDescription: "Could not load resource")
//        }
//        let sample = try JSONDecoder().decode(SampleResource.self, from: resourceData)
//        return sample.message
        return "### FIXME"
    }

    struct SampleResource : Decodable {
        public let message: String
    }

    public func parseRemoteResources(secure: Bool) async throws -> String {
        let `protocol` = (secure ? "https" : "http")
        let (data, response) = try await URLSession.shared.data(from: URL(string:  "\(`protocol`)://jsonplaceholder.typicode.com/todos/1")!)
        if !(200..<300).contains((response as? HTTPURLResponse)?.statusCode ?? 0) {
            throw NativeError(errorDescription: "Bad response for request: \(response)")
        }

        let user = try JSONDecoder().decode(SampleUser.self, from: data)
        return user.title
    }

    /// Sample from https://jsonplaceholder.typicode.com
    struct SampleUser : Identifiable, Decodable {
        let userId: Int
        let id: Int
        let title: String
        let completed: Bool
    }

    public func throwError() throws {
        // TODO: implement Android resources for NSLocalizedString
        // 10-27 12:08:20.520 19166 19166 F DEBUG   : Abort message: 'AppDroidModel/resource_bundle_accessor.swift:12: Fatal error: could not load resource bundle: from /system/bin/skipapp-appdroid_AppDroidModel.resources or /Users/marc/Library/Developer/Xcode/DerivedData/Skip-Everything-aqywrhrzhkbvfseiqgxuufbdwdft/SourcePackages/plugins/skipapp-appdroid.output/AppDroidModel/skipstone/AppDroidModel/src/main/swift/.build/aarch64-unknown-linux-android24/debug/skipapp-appdroid_AppDroidModel.resources'
        //throw NativeError(errorDescription: isAndroid ? "Native Swift Error" : NSLocalizedString("Native Swift Error", bundle: .module, comment: "localized error message"))
        throw NativeError(errorDescription: "Native Swift Error")
    }

    public func crash() {
        fatalError("CRASH BUTTON TAPPED")
    }
}

struct NativeError: LocalizedError {
    let errorDescription: String?

    init(errorDescription: String) {
        self.errorDescription = errorDescription
    }
}

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

@Observable public class HSLValues {
    public var hue = 0.5
    public var saturation = 0.5
    public var brightness = 0.5
    public var opacity = 1.0

    public init() {
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
