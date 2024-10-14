// This is free software: you can redistribute and/or modify it
// under the terms of the GNU General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation

// SKIP @bridgeToKotlin
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

// SKIP @bridgeToKotlin
public func getJavaSystemPropertyViaSwift(name: String) -> String? {
    getJavaSystemProperty(name)
}

// FIXME: cannot bridge unnamed parameters
// public func getJavaSystemPropertyViaSwift(_ name: String) -> String?

// SKIP @bridgeToKotlin
public var bridgedString = "😀" + "🚀"

// SKIP @bridgeToKotlin
public var swiftClosure1Var: (Int) -> String = { i in "value = \(i)" }

// SKIP @bridgeToKotlin
public class SwiftClass {
    public var intVar = 1
    public var optionalIntVar: Int? = nil

    public init() {
    }

    public func getString() -> String {
        "SwiftClass"
    }
}


// SKIP @bridgeToKotlin
public class ObservableFacade {
    // the un-bridged Observable implementation
    private let observable = ObservableClass()

    /// Pass-through of the `doubleVar` property to the internal Observable
    public var doubleVar: Double {
        get { observable.doubleVar }
        set { observable.doubleVar = newValue }
    }

    /// The callback to invoke whenever the observed `doubleVar` changes
    public var callback: (Double) -> Void = { d in } {
        didSet {
            setupCallback()
        }
    }

    @discardableResult private func setupCallback() -> Double {
        withObservationTracking {
            observable.doubleVar
        } onChange: {
            _ = self.callback(self.observable.doubleVar)
            // withObservationTracking is single-shot, so every time we
            // invoke the callback it will be cleared, so we re-assign
            // the callback on every change
            self.setupCallback()
        }
    }

    public init() {
    }
}


#if !SKIP

// FIXME: need to not Skip process @Observable or the Kotlin will import androidx.compose.runtime.mutableStateOf (which won't be found if the module only imports SkipLib/SkipFoundation and not SkipModel/SkipUI)
import Observation
#endif

// un-bridged @Observable instance

@available(macOS 14.0, iOS 17.0, *)
@Observable public class ObservableClass {
    public var doubleVar = 0.0

    public init() {
    }
}

// Without this we get the crash on launch: 08-09 18:45:51.978 10431 10431 E AndroidRuntime: java.lang.UnsatisfiedLinkError: dlopen failed: cannot locate symbol "_ZN5swift9threading5fatalEPKcz" referenced by "/data/app/~~aevIacTPjMLuc5Cymf5l-A==/skip.droid.app--cf8i3s7JV9Ln9saNnThMg==/base.apk!/lib/arm64-v8a/libswiftObservation.so"...
@_cdecl("_ZN5swift9threading5fatalEPKcz")
func bogusFunctionForObservableLinkageOnAndroid() { }

