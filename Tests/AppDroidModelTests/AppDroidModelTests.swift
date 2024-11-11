import XCTest
import Foundation
import SkipBridge
import Observation
import SkipAndroidBridge
@testable import AppDroidModel

@available(macOS 13, *)
final class AppDroidModelTests: XCTestCase {
    override func setUp() {
        #if SKIP
        loadPeerLibrary(packageName: "skipapp-appdroid", moduleName: "AppDroidModel")
        #endif
    }

    func testAppDroidModel() throws {
        #if SKIP
        XCTAssertEqual("/", getJavaSystemProperty("file.separator"))
        #else
        throw XCTSkip("getJavaSystemProperty only works in transpiled test")
        #endif
    }

    func testClosure() {
        XCTAssertEqual("value = 1", swiftClosure1Var(1))
    }

    func testAndroidBridgeHelper() {
        XCTAssertEqual("AB", testSupport_appendStrings("A", "B"))
    }

    func testObservable() {
        let vm = ViewModel()
        var changes = 0
        XCTAssertEqual(vm.color.values.hue, 0.5)
        #if !SKIP
        let _ = withObservationTracking({ vm.color.values.hue }, onChange: { changes += 1 })
        #endif
        vm.color.values.hue += 0.1
        XCTAssertEqual(vm.color.values.hue, 0.6)
        #if !SKIP
        XCTAssertEqual(changes, 1)
        #endif
    }
}
